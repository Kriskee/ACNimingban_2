//
//  KHTMLabel.m
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 刘超凯. All rights reserved.
//

#import "KHTMLabel.h"

@implementation KHTMLabel
/**
 * attrString:属性字符串对象,可将字符串赋予颜色,字体甚至处理含HTML标签的字符串
 * 该方法可以将含有 "HTML标签" 的字符串进行转换,生成带有原本样式的字符串并放入Label中
 * 该方法查自:http://blog.csdn.net/meegomeego/article/details/40153199
 * 只可在iOS7之后使用!
 */

+ (void)html2PlainText:(NSString *)htmlString inLabel:(UILabel *)label setting:(void(^)())setting{
    // HTML字符串转换
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    // 放入Label中
    [label setAttributedText:attrString];
    // 设置字体
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    // Label属性设置Block,需要判断block是否为空
    if(setting == nil){
    }else{
        setting();
    }
}


@end