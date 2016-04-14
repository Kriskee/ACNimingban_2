//
//  PlateModel.h
//  ACNimingban
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 刘超凯. All rights reserved.
//
/**
 * Plate 和 Thread 公用Model
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PlateModel : NSObject
@property(nonatomic,copy)NSString *admin;         // 是否为管理员发串(1/0否)
@property(nonatomic,copy)NSString *content;       // 串内容(基本相当于标题)
@property(nonatomic,copy)NSString *createdAt;     // 发串时间(1970毫秒级)
@property(nonatomic,copy)NSString *email;         // *邮箱
@property(nonatomic,copy)NSString *Tid;           // 串id
@property(nonatomic,copy)NSString *image;         // 图片
@property(nonatomic,copy)NSString *name;          // 发串名称
//@property(nonatomic,copy)NSString *recentReply:[] // 最近回复串id
@property(nonatomic,copy)NSString *replyCount;    // 总回复数
@property(nonatomic,copy)NSString *thumb;         // 缩略图
@property(nonatomic,copy)NSString *title;         // *串标题
@property(nonatomic,copy)NSString *uid;           // po id(发串人)

// 储存图片和缩略图
@property(nonatomic,strong)UIImage *pImage;
@property(nonatomic,strong)UIImage *pThumb;

// 缩略图宽高
@property(nonatomic,assign)double thumbW;
@property(nonatomic,assign)double thumbH;
/** 缩略图高宽比 */
@property(nonatomic,assign)double thumbH2W;
@end
