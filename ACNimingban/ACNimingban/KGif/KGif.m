//
//  KGif.m
//  Test
//
//  Created by lanou3g on 16/1/26.
//  Copyright © 2016年 刘超凯. All rights reserved.
//

#import "KGif.h"

@implementation KGif
+ (void) gifWithImageName:(NSString*)name webView:(UIWebView*)webView setting:(void(^)())setting{
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 禁止滚动
    webView.scrollView.scrollEnabled = NO;
    // 适应视图Frame
    webView.scalesPageToFit = YES;
    // 背景透明, 背景透明色和不透明都设置
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    // 加载
    [webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    // Block安全判断
    if(setting == nil){
    }else{
        setting();
    }
}

+ (void)gifWithImagePath:(NSString*)path webView:(UIWebView*)webView setting:(void(^)())setting{
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 禁止滚动
    webView.scrollView.scrollEnabled = NO;
    // 适应视图Frame
    webView.scalesPageToFit = YES;
    // 背景透明, 背景透明色和不透明都设置
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    // 加载
    [webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    // Block安全判断
    if(setting == nil){
    }else{
        setting();
    }
}

+ (void)gifWithImageURL:(NSString*)urlString webView:(UIWebView*)webView setting:(void(^)())setting{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 禁止滚动
    webView.scrollView.scrollEnabled = NO;
    // 适应视图Frame
    webView.scalesPageToFit = YES;
    // 背景透明, 背景透明色和不透明都设置
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    // 加载
    [webView loadRequest:request];
    // Block安全判断
    if(setting == nil){
    }else{
        setting();
    }
}
@end







