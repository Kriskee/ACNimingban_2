//
//  PlateTableViewCell.h
//  ACNimingban
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 刘超凯. All rights reserved.
//
/**
 * PlateTableViewController(话题串列表) 和 ThreadTableViewController(串回复列表) 共用Cell
 */

#import <UIKit/UIKit.h>

@interface PlateTableViewCell : UITableViewCell
// 内容Label
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
// 回复日期
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
// 回复用户id
@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
// 回复数量/回复串id
@property (weak, nonatomic) IBOutlet UILabel *replyCount;
// 静态图view
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
// 图片的高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgH;
// 动态图view
@property (weak, nonatomic) IBOutlet UIWebView *gifView;
// 动态图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gifH;
// 动态图点击手势覆盖视图
@property (weak, nonatomic) IBOutlet UIView *actView;
@end
