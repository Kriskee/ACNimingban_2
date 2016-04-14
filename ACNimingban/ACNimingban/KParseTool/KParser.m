//
//  KParser.m
//  Work_17_ToolClass
//
//  Created by lanou3g on 15/12/29.
//  Copyright © 2015年 刘超凯. All rights reserved.
//

#import "KParser.h"

@implementation KParser
+ (void)parseWithURL:(NSString*)urlString
          httpMethod:(NSString*)method
            httpBody:(NSString*)body
              isIOS9:(BOOL)judge
             handler:(dataBlock)block{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *SMethod = [method uppercaseString];
    if([SMethod isEqualToString:@"POST"]){
        [request setHTTPMethod:@"POST"];
        NSData *dataP = [body dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:dataP];
    }else if([SMethod isEqualToString:@"GET"]){
    }else{
        NSLog(@"参数错误");
        return;
    }
    if(judge){
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            block(data);
        }];
        [task resume];
    }else{
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            block(data);
        }];
    }
}

+ (void)imageShowWithURL:(NSString *)urlString
                 handler:(imageBlock)block{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(image);
        });
    }];
    [task resume];
}
@end
