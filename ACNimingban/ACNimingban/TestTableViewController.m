//
//  TestTableViewController.m
//  ACNimingban
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 刘超凯. All rights reserved.
//

#import "TestTableViewController.h"
#import "KParser.h"
#import "ForumModel.h"
#import "PlateTableViewController.h"
#import "ForumTableViewCell.h"
#import "PlateManager.h"
#define URL @"http://cover.acfunwiki.org/cn.json"

@interface TestTableViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 延迟启动加载,启动动画时间
    [NSThread sleepForTimeInterval:3];
    
    self.data = [NSMutableArray array];
    self.navigationItem.title = @"A岛";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // self.clearsSelectionOnViewWillAppear = NO;
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ForumTableViewCell" bundle:nil] forCellReuseIdentifier:@"forumCell"];
    [self dataMake];
}

#pragma mark - Data Make 数据解析
- (void)dataMake{
    [KParser parseWithURL:URL httpMethod:@"GET" httpBody:nil isIOS9:YES handler:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"forum"];
        for (NSDictionary *dic in array) {
            ForumModel *model = [ForumModel new];
            [model setValuesForKeysWithDictionary:dic];
            [self.data addObject:model];
            NSLog(@"NAME:%@ ID:%@ LOCK:%@ CD:%@", model.name, model.Aid, model.lock, model.cooldown);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 表示图设置
#pragma mark cell点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlateTableViewController *PVC = [PlateTableViewController new];
    ForumModel *model = self.data[indexPath.row];
    PVC.plateTitle = model.name;
    PVC.plateData = self.data;
    [self.navigationController pushViewController:PVC animated:YES];
}

#pragma mark - 如果页面跳回(即将出现,清空单例数据)
- (void)viewWillAppear:(BOOL)animated{
    if([PlateManager shareInstance].data){
        [[PlateManager shareInstance]emptyData];
    }
}

#pragma mark Row数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

#pragma mark cell重用:每个cell为一个板块
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ForumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forumCell" forIndexPath:indexPath];
    ForumModel *model = self.data[indexPath.row];
    cell.plateName.text = model.name;
    return cell;
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
