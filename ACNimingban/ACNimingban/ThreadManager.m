//
//  ThreadManager.m
//  ACNimingban
//
//  Created by lanou3g on 16/2/24.
//  Copyright © 2016年 刘超凯. All rights reserved.
//

#import "ThreadManager.h"
#import "KParser.h"
#import "PlateModel.h"

@implementation ThreadManager
ThreadManager *manager2 = nil;
#pragma mark - 创建单例
+ (instancetype)shareInstance{
    if(!manager2){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager2 = [ThreadManager new];
        });
    }
    return manager2;
}

// 懒加载
- (NSMutableArray *)data{
    if(!_data){
        _data = [NSMutableArray array];
    }
    return _data;
}

#pragma mark - 数据加载
- (void)parserDataWithThreadId:(NSString *)Tid page:(NSInteger)page handler:(void (^)())block{
    [KParser parseWithURL:[NSString stringWithFormat:@"http://h.nimingban.com/api/t/%@?page=%ld", Tid, page] httpMethod:@"GET" httpBody:nil isIOS9:YES handler:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"replys"];
        for (NSDictionary *dic2 in array) {
            PlateModel *model = [PlateModel new];
            [model setValuesForKeysWithDictionary:dic2];
            [self.data addObject:model];
            // 图片加载
            [model setPThumb:nil];
        }
        // 回到主线程,刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
            block();
        });
    }];
}

#pragma mark - 数据清空
- (void)dataEmpty{
    [self.data removeAllObjects];
}
@end
