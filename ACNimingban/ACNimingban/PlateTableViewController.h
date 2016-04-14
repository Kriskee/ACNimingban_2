//
//  PlateTableViewController.h
//  ACNimingban
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 刘超凯. All rights reserved.
//
/*
 A岛板块页面,串头话题页面
 */

#import <UIKit/UIKit.h>

@interface PlateTableViewController : UITableViewController
// 板块名称
@property(nonatomic,copy)NSString *plateTitle;
// 板块数据
@property(nonatomic,strong)NSMutableArray *plateData;
@end
