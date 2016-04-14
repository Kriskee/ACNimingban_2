//
//  KGetTime.h
//  KGetTime
//
//  Created by lanou3g on 16/1/8.
//  Copyright © 2016年 刘超凯. All rights reserved.
//

/********************************************
 * This Class is created for getting NOW    *
 * DATE more simply and easily.             *
 * You can get now hour, minute and second. *
 * Of cause, you can get date by formatter. *
 ********************************************/

#import <Foundation/Foundation.h>

@interface KGetTime : NSObject
+ (NSInteger)nowHour_24;
+ (NSInteger)nowHour_12;
+ (NSInteger)nowMinute;
+ (NSInteger)nowSecond;
+ (NSString*)nowDate:(NSString*)formatter_;
+ (NSString*)getDateForSec:(NSInteger)seconds formatter:(NSString*)formatter_;
@end
