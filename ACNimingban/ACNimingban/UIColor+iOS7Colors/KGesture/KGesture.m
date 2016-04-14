//
//  KGesture.m
//
//  Created by 刘超凯 on 16/1/12.
//  Copyright © 2016年 刘超凯. All rights reserved.
//

#import "KGesture.h"

@implementation KGesture
+ (void)gesturePanWithGesture:(UIPanGestureRecognizer*)recognizer{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}

+ (void)gestureRotationWithGesture:(UIRotationGestureRecognizer*)recognizer{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}

+ (void)gesturePinchWithGesture:(UIPinchGestureRecognizer*)recognizer{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}
@end
