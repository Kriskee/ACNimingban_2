//
//  ThreadManager.h
//  ACNimingban
//
//  Created by lanou3g on 16/2/24.
//  Copyright © 2016年 刘超凯. All rights reserved.
//
/*
 * 讨论串数据处理管理类
 */

#import <Foundation/Foundation.h>

@interface ThreadManager : NSObject
// 讨论串回复数据
@property(nonatomic,strong)NSMutableArray *data;

// 单例
+ (instancetype)shareInstance;

/**
 * @brief 讨论串数据加载
 * @param Tid 讨论串id
 * @param page 页数
 * @param block 自定义块
 * @return (void)
 */
- (void)parserDataWithThreadId:(NSString*)Tid page:(NSInteger)page handler:(void(^)())block;

/**
 * @brief 数据清空
 * @param void
 * @return void
 */
- (void)dataEmpty;
@end
