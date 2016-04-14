//
//  ThreadTableViewController.h
//  ACNimingban
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 刘超凯. All rights reserved.
//
/**
 * 串话题的回复页面
 */
#import <UIKit/UIKit.h>
#import "PlateModel.h"
@interface ThreadTableViewController : UITableViewController
// 从 PlateTableViewController 传回选中 cell 的 model
@property(nonatomic,strong)PlateModel *model;
@end
