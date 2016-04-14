//
//  KHTMLabel.h
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 刘超凯. All rights reserved.
//
/***********************************
 * 将含HTML语句文本(JSON解析数据)转换为
 * 带格式文本 
 * 引用方法文件为:"KHTMLabel.h"
 ***********************************/

/**
 * NSAttributedString的字符属性:
 * NSString *const NSFontAttributeName;               (字体)
 * NSString *const NSParagraphStyleAttributeName;     (段落)
 * NSString *const NSForegroundColorAttributeName;    (字体颜色)
 * NSString *const NSBackgroundColorAttributeName;    (字体背景色)
 * NSString *const NSLigatureAttributeName;           (连字符)
 * NSString *const NSKernAttributeName;               (字间距)
 * NSString *const NSStrikethroughStyleAttributeName; (删除线)
 * NSString *const NSUnderlineStyleAttributeName;     (下划线)
 * NSString *const NSStrokeColorAttributeName;        (边线颜色)
 * NSString *const NSStrokeWidthAttributeName;        (边线宽度)
 * NSString *const NSShadowAttributeName;             (阴影)
 * NSString *const NSVerticalGlyphFormAttributeName;  (横竖排版)
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KHTMLabel : NSObject
/**
 * @brief 将HTML文本转换成属性文本放入Label中,默认字体为:(Helvetica-Bold, 17)
 *
 * @param htmlString 含HTML语法的字符串 
 * @param label 需要写入字符串的标签 
 * @param setting 对Label进行属性设置的Block
 *
 * @return (void)
 */
+ (void)html2PlainText:(NSString*)htmlString inLabel:(UILabel*)label setting:(void(^)())setting;
@end
















