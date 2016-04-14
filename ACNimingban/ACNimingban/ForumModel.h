//
//  ForumModel.h
//  ACNimingban
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 刘超凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForumModel : NSObject
@property(nonatomic,copy)NSString *cooldown;
//@property(nonatomic,assign)NSInteger *Aid;      // 板块id
@property(nonatomic,copy)NSString *Aid;
@property(nonatomic,copy)NSString *lock;          // 是否锁区(def:false)
@property(nonatomic,copy)NSString *name;        // 板块名称
@end
