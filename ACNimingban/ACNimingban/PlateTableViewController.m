//
//  PlateTableViewController.m
//  ACNimingban
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 刘超凯. All rights reserved.
//

#import "PlateTableViewController.h"
#import "PlateTableViewCell.h"
#import "ThreadTableViewController.h"
#import "ShowImageViewController.h"
#import "KParser.h"
#import "KGetTime.h"
#import "KHTMLabel.h"
#import "KGif.h"
#import "ForumModel.h"
#import "PlateModel.h"
#import "PlateManager.h"
#import "MJRefresh.h"
#import "ThreadManager.h"
#define URL @"http://h.nimingban.com/api/"

@interface PlateTableViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
// 板块页码
@property(nonatomic,assign)NSInteger page;
// 设置抽屉
@property(nonatomic,strong)UIView *locker;
// 抽屉table
@property(nonatomic,strong)UITableView *lockerTable;
@end

@implementation PlateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    self.navigationItem.title = self.plateTitle;
    
    // 设置右上角按钮
    UIBarButtonItem *locker = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"locker.png"] style:UIBarButtonItemStylePlain target:self action:@selector(lockerAction)];
    self.navigationItem.rightBarButtonItem = locker;
    // 设置界面左滑事件
    UISwipeGestureRecognizer *toLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lockerAction)];
    toLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:toLeft];
    // 设置抽屉
    [self setLocker];
    
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // self.clearsSelectionOnViewWillAppear = NO;
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"PlateTableViewCell" bundle:nil] forCellReuseIdentifier:@"plateCell"];
    // 自适应高度 & 最小高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 10;
    [self dataMake];
    
    // 集成刷新
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Data Make 数据解析
- (void)dataMake{
    [[PlateManager shareInstance] parserDataWithPlateName:self.plateTitle page:self.page handler:^{
        [self.tableView reloadData];
    }];
}

#pragma mark - 右侧边栏抽屉设置
- (void)setLocker{
    // 设置抽屉
    self.locker = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tableView.frame), 0, 200, CGRectGetHeight([UIScreen mainScreen].bounds))];
    self.locker.backgroundColor = [UIColor purpleColor];
    [self.tableView addSubview:self.locker];
    // 设置抽屉Table
    self.lockerTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, self.locker.frame.size.height-64) style:UITableViewStylePlain];
    // 代理
    self.lockerTable.delegate = self;
    self.lockerTable.dataSource = self;
    self.lockerTable.bounces = NO;
    [self.locker addSubview:self.lockerTable];
    [self.lockerTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"lockerCell"];
}

#pragma mark 抽屉弹出与退回
/** 右抽屉是否弹出 */
BOOL isLocker = NO;
- (void)lockerAction{
//    if(isLocker == NO){
//        // 抽屉弹出
//        [UIView beginAnimations:nil context:nil];
//        CGRect frame2 = self.locker.frame;
//        frame2.origin = CGPointMake(frame2.origin.x - 200, self.tableView.contentOffset.y+64);
//        self.locker.frame = frame2;
//        [UIView commitAnimations];
//        // 抽屉弹出禁止滚动
//        self.tableView.scrollEnabled = NO;
//        isLocker = YES;
//    }else{
//        // 抽屉弹回
//        [UIView beginAnimations:nil context:nil];
//        CGRect frame2 = self.locker.frame;
//        frame2.origin.x = CGRectGetMaxX(self.tableView.frame);
//        self.locker.frame = frame2;
//        [UIView commitAnimations];
//        // 抽屉弹回,可以滚动
//        self.tableView.scrollEnabled = YES;
//        isLocker = NO;
//    }
    [self isLockerFunc];
}

//
- (void)isLockerFunc{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.locker.frame;
    CGFloat x = isLocker?CGRectGetMaxX(self.tableView.frame):(frame.origin.x - 200);
    CGFloat y = isLocker?CGRectGetMinY(self.locker.frame):(self.tableView.contentOffset.y+64);
    frame.origin = CGPointMake(x, y);
    self.locker.frame = frame;
    [UIView commitAnimations];
    self.tableView.scrollEnabled = isLocker;
    isLocker = !isLocker;
}
//

#pragma mark - 使用观察监控视图滚动
#pragma mark 即将加载视图, 创建观察者
- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"观察者【创建】");
    isLocker = NO;
    self.tableView.scrollEnabled = YES;
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    // 板块视图出现,讨论串视图消失，清空讨论串视图数据
    [[ThreadManager shareInstance] dataEmpty];
}

#pragma mark 观察者方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"contentOffset"]){
        NSLog(@"滚动事件");
        CGRect frame2 = self.locker.frame;
        frame2.origin.y = self.tableView.contentOffset.y+64;
        self.locker.frame = frame2;
    }
}

#pragma mark 视图即将消失, 销毁观察者
- (void)viewWillDisappear:(BOOL)animated{
    CGRect frame2 = self.locker.frame;
    frame2.origin.x = CGRectGetMaxX(self.tableView.frame);
    self.locker.frame = frame2;
    NSLog(@"观察者【销毁】");
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}


#pragma mark - Table view data source
#pragma mark 点击cell跳转到下一页面 / 加载板块,刷新页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView){
        // 当抽屉弹出,点击不跳转,而是抽屉收回
        if(isLocker == YES){
            [UIView beginAnimations:nil context:nil];
            CGRect frame2 = self.locker.frame;
            frame2.origin.x = CGRectGetMaxX(self.tableView.frame);
            self.locker.frame = frame2;
            [UIView commitAnimations];
            isLocker = NO;
            return;
        }
        // 跳转至对应串
        ThreadTableViewController *TVC = [ThreadTableViewController new];
        PlateModel *model = /*self.data*/[PlateManager shareInstance].data[indexPath.row];
        TVC.model = model;
        [self.navigationController pushViewController:TVC animated:YES];
    }
    if(tableView == self.lockerTable){
        // 加载新板块页面
        // 清空管理类中存储数据,清空后显示空白
        [[PlateManager shareInstance] emptyData];
        [self.tableView reloadData];
        // 侧边栏退回
        [self isLockerFunc];
        
        // 获取并【更换】板块名称；页码重新指向第一页；数据重新解析
        ForumModel *model = self.plateData[indexPath.row];
        _page = 1;
        self.plateTitle = model.name;
        [[PlateManager shareInstance] parserDataWithPlateName:model.name page:self.page handler:^{
            [self.tableView reloadData];
        }];
        
        // Navigation标题更换
        self.navigationItem.title = model.name;
    }
}

#pragma mark 设置row数以及cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowCount = 0;
    if(tableView == self.tableView){
        rowCount = (int)/*self.data.count*/ [PlateManager shareInstance].data.count;
    }if(tableView == self.lockerTable){
        rowCount = (int)self.plateData.count;
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *tCell;
    
    if(tableView == self.tableView){
        
    PlateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plateCell" forIndexPath:indexPath];
    PlateModel *model = [PlateManager shareInstance].data[indexPath.row];
    
    // 发串时间
    cell.dateLabel.text = [KGetTime getDateForSec:[model.createdAt integerValue]/1000 formatter:@"yy/MM/dd HH:mm:ss"];
    
    // 发串者id:注意红名为管理员
    [KHTMLabel html2PlainText:model.uid inLabel:cell.uidLabel setting:nil];
    
    // 回复数
    cell.replyCount.text = [@"回复:" stringByAppendingString:model.replyCount];
    
    // 串话题内容
    NSString *str = [NSString stringWithFormat:@"%@%@%@", model.title, model.name, model.content];
    [KHTMLabel html2PlainText:str inLabel:cell.contentLabel setting:nil];
    
    // 图片点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAction:)];
    // 图片展示:动态图,无图,静态图
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
        // 开启交互,添加点击手势
        cell.imgView.userInteractionEnabled = YES;
        [cell.imgView addGestureRecognizer:tap];
    }
    
    // cell底色:灰
    cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tCell = cell;
//        return cell;
    }
    
    if(tableView == self.lockerTable){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lockerCell"];
        ForumModel *model = self.plateData[indexPath.row];
        cell.textLabel.text = model.name;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor darkGrayColor];
        tCell = cell;
    }
    return tCell;
}

#pragma mark - 图片点击事件
- (void)showImageAction:(UITapGestureRecognizer*)tap{
    // 通过手势对应的view的父视图,一级一级向上直到探寻到cell找到对应的indexPath
    NSIndexPath *index = [self.tableView indexPathForCell:(UITableViewCell*)tap.view.superview.superview];
    NSLog(@"%ld", index.row);
    // 跳转至图片查看页面
    ShowImageViewController *SVC = [ShowImageViewController new];
    PlateModel *model = [PlateManager shareInstance].data[index.row];
    SVC.model = model;
    [self.navigationController pushViewController:SVC animated:YES];
}

#pragma mark - 上下拉集成刷新
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
    // 页码归1
    _page = 1;
    // 清空数据（清空放在外面会崩溃），重新加载刷新数据,设置2秒后完成
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[PlateManager shareInstance] emptyData];
        [[PlateManager shareInstance]parserDataWithPlateName:self.plateTitle page:self.page handler:^{
            [self.tableView reloadData];
        }];
        [self.tableView headerEndRefreshing];
    });
}

// 上拉加载
- (void)footerRefreshing{
    // 页码加1
    _page++;
    // 上拉刷新数据，设置2秒完成
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[PlateManager shareInstance]parserDataWithPlateName:self.plateTitle page:self.page handler:^{
            [self.tableView reloadData];
        }];
        [self.tableView footerEndRefreshing];
    });
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 500;
//}

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
