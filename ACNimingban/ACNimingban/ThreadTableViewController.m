//
//  ThreadTableViewController.m
//  ACNimingban
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 刘超凯. All rights reserved.
//

#import "ThreadTableViewController.h"
#import "ShowImageViewController.h"
#import "KParser.h"
#import "KGetTime.h"
#import "KHTMLabel.h"
#import "KGif.h"
#import "PlateModel.h"
#import "PlateTableViewCell.h"
#import "ThreadManager.h"
#import "MJRefresh.h"
#define URL @"http://h.nimingban.com/api/t/"

@interface ThreadTableViewController ()
// 讨论串页码
@property(nonatomic,assign)NSInteger page;
@end

@implementation ThreadTableViewController

- (void)viewDidLoad {
    _page = 1;
    [super viewDidLoad];
    
    // 管理类数据
    [[ThreadManager shareInstance].data addObject:self.model];
    
    self.navigationItem.title = [NSString stringWithFormat:@"No.%@", self.model.Tid];
    // self.clearsSelectionOnViewWillAppear = NO;
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"PlateTableViewCell" bundle:nil] forCellReuseIdentifier:@"plateCell"];
    // 不使用分隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // cell自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 10;
    
    // 数据处理
    [self dataMake];
    
    // 集成刷新控件
    [self setupRefresh];
}

#pragma mark - 数据处理
- (void)dataMake{
    [[ThreadManager shareInstance] parserDataWithThreadId:self.model.Tid page:self.page handler:^{
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
#pragma mark 表示图row和cell设置
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"数据：%ld", [ThreadManager shareInstance].data.count);
    return [ThreadManager shareInstance].data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 设置cell
    PlateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plateCell" forIndexPath:indexPath];
    
    // 获取当前model
    PlateModel *model = [ThreadManager shareInstance].data[indexPath.row];

    // 回复时间
    cell.dateLabel.text = [KGetTime getDateForSec:[model.createdAt integerValue]/1000 formatter:@"yy/MM/dd HH:mm:ss"];
    
    // 回复用户id: 需要判断是否为po主发串
    if([model.uid isEqualToString:self.model.uid]){
        [KHTMLabel html2PlainText:model.uid inLabel:cell.uidLabel setting:^{
            NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:@"(po主)" attributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:12]}];
            NSMutableAttributedString *uidString = [[NSMutableAttributedString alloc] initWithAttributedString:cell.uidLabel.attributedText];
            [uidString appendAttributedString:attrString];
            cell.uidLabel.attributedText = uidString;
        }];
    }else{
        [KHTMLabel html2PlainText:model.uid inLabel:cell.uidLabel setting:nil];
    }
    
    // 回复串id
    cell.replyCount.text = [NSString stringWithFormat:@"No.%@", model.Tid];
    
    // 回复内容
    [KHTMLabel html2PlainText:model.content inLabel:cell.contentLabel setting:nil];
    
    // 图片点击事件-查看图片
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAction:)];
    // 加载图片:动态图,无图,静态图
    if([model.thumb hasSuffix:@"gif"]|[model.thumb hasSuffix:@"GIF"]){
        cell.imgH.constant = 0;
        cell.gifH.constant = cell.gifView.frame.size.width * model.thumbH2W;
        [KGif gifWithImageURL:[@"http://cdn.ovear.info:8998" stringByAppendingString:model.thumb] webView:cell.gifView setting:nil];
        // 添加点击手势
        [cell.actView addGestureRecognizer:tap];
    }else if([model.thumb isEqualToString:@""]){
        cell.imgH.constant = 0;
        cell.gifH.constant = 0;
    }else{
        cell.gifH.constant = 0;
        cell.imgH.constant = cell.imgView.frame.size.width * model.thumbH2W;
        cell.imgView.image = model.pThumb;
        // 启动交互，添加手势
        cell.imgView.userInteractionEnabled = YES;
        [cell.imgView addGestureRecognizer:tap];
    }
    
    // cell底色
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - 图片点击事件
- (void)showImageAction:(UITapGestureRecognizer*)tap{
    // 通过手势对应的view的父视图,一级一级向上直到探寻到cell找到对应的indexPath
    NSIndexPath *index = [self.tableView indexPathForCell:(UITableViewCell*)tap.view.superview.superview];
    // 跳转至图片查看页面
    ShowImageViewController *SVC = [ShowImageViewController new];
    PlateModel *model = [ThreadManager shareInstance].data[index.row];
    SVC.model = model;
    
    [self.navigationController pushViewController:SVC animated:YES];
}

#pragma mark - 集成刷新控件
- (void)setupRefresh{
    // 下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    // 上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    self.tableView.headerRefreshingText = @"数据刷新ing...";
    self.tableView.footerRefreshingText = @"数据加载ing...";
}

// 下拉刷新
- (void)headerRefreshing{
    _page = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ThreadManager shareInstance] dataEmpty];
        [[ThreadManager shareInstance].data addObject:self.model];
        [[ThreadManager shareInstance]parserDataWithThreadId:self.model.Tid page:self.page handler:^{
            [self.tableView reloadData];
        }];
        [self.tableView headerEndRefreshing];
    });
}

// 上拉加载
- (void)footerRefreshing{
    // 如果数据个数大于等于回复数，不加载
    PlateModel *model = [[ThreadManager shareInstance].data objectAtIndex:0];
    if([ThreadManager shareInstance].data.count >= [model.replyCount integerValue]+1){
        [self.tableView footerEndRefreshing];
        return;
    };
    
    // 数据加载
    _page++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ThreadManager shareInstance]parserDataWithThreadId:self.model.Tid page:self.page handler:^{
            [self.tableView reloadData];
        }];
        [self.tableView footerEndRefreshing];
    });
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
