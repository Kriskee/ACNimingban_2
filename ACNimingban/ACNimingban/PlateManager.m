//
//  parserManager.m
//  ACNimingban
//
//  Created by lanou3g on 16/1/29.
//  Copyright © 2016年 刘超凯. All rights reserved.
//

#import "PlateManager.h"
#import "PlateModel.h"
#import "KParser.h"

@implementation PlateManager
PlateManager *manager = nil;
#pragma mark - 创建单例
+ (instancetype)shareInstance{
    if(!manager){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [PlateManager new];
        });
    }
    return manager;
}

#pragma mark - data懒加载
- (NSMutableArray *)data{
    if(!_data){
        _data = [NSMutableArray array];
    }
    return _data;
}

#pragma mark - 板块内容加载
- (void)parserDataWithPlateName:(NSString*)name page:(NSInteger)page handler:(void(^)())block{
    // URL创建
    NSString *urlCode = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://h.nimingban.com/api/%@?page=%ld", urlCode, page];
    // 解析
    [KParser parseWithURL:url httpMethod:@"GET" httpBody:nil isIOS9:YES handler:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *sonDic = dic[@"data"];
        NSArray *array = sonDic[@"threads"];
        for (NSDictionary *dic in array) {
            PlateModel *model = [PlateModel new];
            [model setValuesForKeysWithDictionary:dic];
            [self.data addObject:model];
            // 图片加载
            [model setPThumb:nil];
        }
        // 回归主线程刷新
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
//            [self.tableView reloadData];
        });
    }];
}

#pragma mark - 清空数据
- (void)emptyData{
    [self.data removeAllObjects];
}
@end
