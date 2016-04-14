//
//  KParser.h
//  Work_17_ToolClass
//
//  Created by lanou3g on 15/12/29.
//  Copyright © 2015年 刘超凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^dataBlock)(NSData *data);
typedef void(^imageBlock)(UIImage *image);

@interface KParser : NSObject
+ (void)parseWithURL:(NSString*)urlString
          httpMethod:(NSString*)method
            httpBody:(NSString*)body
              isIOS9:(BOOL)judge
             handler:(dataBlock)block;

+ (void)imageShowWithURL:(NSString *)urlString
                 handler:(imageBlock)block;
@end
