//
//  parserManager.h
//  ACNimingban
//
//  Created by lanou3g on 16/1/29.
//  Copyright © 2016年 刘超凯. All rights reserved.
//
/**
 数据处理的管理类
 */

#import <Foundation/Foundation.h>

@interface PlateManager : NSObject
// 板块内容数据
@property(nonatomic,strong)NSMutableArray *data;

// 单例
+(instancetype)shareInstance;
/** 数据加载
 * @param name 板块名
 * @param page 页码
 * @param block 自定义块
 * @return (void)
 */
- (void)parserDataWithPlateName:(NSString*)name page:(NSInteger)page handler:(void(^)())block;

/** 清空数据
 @ param (void)
 */
- (void)emptyData;
@end
