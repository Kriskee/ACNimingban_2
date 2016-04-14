//
//  PlateModel.m
//  ACNimingban
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 刘超凯. All rights reserved.
//

#import "PlateModel.h"
#import "KParser.h"
// image 和 thumb公用接口; 例如:http://cdn.ovear.info:8998/image/2016-01-22/56a1c11ec846a.jpg
#define imgURL @"http://cdn.ovear.info:8998"

@implementation PlateModel
#pragma mark - id 是关键字,使用Tid接收id的值
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        self.Tid = value;
    }
}

#pragma mark - 对name和title进行处理
// 因为使用了KHTMLabel类对htmlString进行了处理,故"\n"需要更换为"<br/>"方能进行换行处理
- (void)setName:(NSString *)name{
    if([name isEqualToString:@""]){
        _name = @"";
    }else{
        _name = [name stringByAppendingString:@"<br/>" /*@"\n"*/];
    }
}

- (void)setTitle:(NSString *)title{
    if([title isEqualToString:@""]){
        _title = @"";
    }else{
        _title = [title stringByAppendingString:@"<br/>" /*@"\n"*/];
    }
}

#pragma mark - 缩略图加载, 以及宽高设置
- (void)setPThumb:(UIImage *)pThumb{
    if([self.thumb isEqualToString:@""]){
        self.thumbH = 0;
        self.thumbW = 0;
        self.thumbH2W = 0;
        return;
    }
    // 缩略图加载
    [KParser imageShowWithURL:[imgURL stringByAppendingString:self.thumb] handler:^(UIImage *image) {
        _pThumb = image;
        // 宽高设置
        dispatch_async(dispatch_get_main_queue(), ^{
            self.thumbH = _pThumb.size.height;
            self.thumbW = _pThumb.size.width;
            self.thumbH2W = self.thumbH/self.thumbW;
        });
    }];
}
@end
