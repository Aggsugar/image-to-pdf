//
//  LRHMTransformManager.h
//  test1
//
//  Created by aggsugar on 15/3/31.
//  Copyright (c) 2015年 aggsugar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRHMTransformManager : NSObject

+ (LRHMTransformManager *)shareTransformManager;

/*
 CGAffineTransform
 */
- (CGAffineTransform)rotateTransformWith:(NSRect)rect withAngle:(CGFloat)angle;           //旋转
- (CGAffineTransform)verticalFlipTransformWith:(NSRect)rect;                              //垂直翻转
- (CGAffineTransform)horizontalFlipTransformWith:(NSRect)rect;                           //水平翻转
@end
