//
//  ShowImageViewController.h
//  ACNimingban
//
//  Created by lanou3g on 16/1/27.
//  Copyright © 2016年 刘超凯. All rights reserved.
//
/**
 * 点击cell查看图片,下载图片
 */
#import <UIKit/UIKit.h>
#import "PlateModel.h"

@interface ShowImageViewController : UIViewController
// 用于接受图片相关对象
@property(nonatomic,strong)PlateModel *model;
@end
