//
//  KGif.h
//  Test
//
//  Created by lanou3g on 16/1/26.
//  Copyright © 2016年 刘超凯. All rights reserved.
//
/**********************************
 * 方法用于播放动态图,使用UIWebView控件
 * Gif图片横向适应(因竖向滑动)
 **********************************/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface KGif : NSObject
/**
 * @brief 使用webView加载和显示本地GIF动态图片,不需要加 ".gif" 后缀
 * @param name GIF图片名称,不需要加 ".gif" 后缀
 * @param webView 加载动态图片的webView视图
 * @param setting 需要对图片或webView进行设置的Block
 * @return (void)
 */
+ (void)gifWithImageName:(NSString*)name webView:(UIWebView*)webView setting:(void(^)())setting;

/**
 * @brief 使用webView加载和显示本地GIF动态图片,需要图片的具体路径
 * @param path GIF图片的路径
 * @param webView 加载动态图片的webView视图
 * @param setting 需要对图片或webView进行设置的Block
 * @return (void)
 */
+ (void)gifWithImagePath:(NSString*)path webView:(UIWebView*)webView setting:(void(^)())setting;

/**
 * @brief 使用webView加载和显示网络GIF动态图片
 * @param urlString GIF图片的网络地址
 * @param webView 加载动态图片的webView视图
 * @param setting 需要对图片或webView进行设置的Block
 * @return (void)
 */
+ (void)gifWithImageURL:(NSString*)urlString webView:(UIWebView*)webView setting:(void(^)())setting;
@end
