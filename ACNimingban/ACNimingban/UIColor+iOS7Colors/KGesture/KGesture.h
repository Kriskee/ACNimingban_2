//
//  KGesture.h
//
//  Created by 刘超凯 on 16/1/12.
//  Copyright © 2016年 刘超凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface KGesture : NSObject
/**
 * @brief 拖拽手势事件处理
 * @param recogniser 拖拽手势事件
 * @return (void)
 */
+ (void)gesturePanWithGesture:(UIPanGestureRecognizer*)recognizer;

/**
 * @brief 旋转手势事件处理
 * @param recogniser 旋转手势事件
 * @return (void)
 */
+ (void)gestureRotationWithGesture:(UIRotationGestureRecognizer*)recognizer;

/**
 * @brief 缩放手势事件处理
 * @param recogniser 缩放手势事件
 * @return (void)
 */
+ (void)gesturePinchWithGesture:(UIPinchGestureRecognizer*)recognizer;
@end


/*
 * 使用手势对象【点】出来的 View 就是手势所操作的view.
 *
 * iOS的基本手势:
 * tap        轻拍
 * longPress  长按: 注意长按事件duration
 * pan        拖移: 改变View点坐标
 * pinch      捏合: 仿射动画缩放
 * rotation   旋转: 仿射动画旋转
 * swipe      轻扫: 注意轻扫方向direction
 * screenEdge 边界触摸: 注意边缘位置edge
 */
