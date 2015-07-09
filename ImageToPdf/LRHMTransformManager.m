//
//  LRHMTransformManager.m
//  test1
//
//  Created by aggsugar on 15/3/31.
//  Copyright (c) 2015年 aggsugar. All rights reserved.
//

#import "LRHMTransformManager.h"

@implementation LRHMTransformManager
+ (LRHMTransformManager *)shareTransformManager
{
    static dispatch_once_t onceToken;
    static LRHMTransformManager *shareManager = nil;
    dispatch_once(&onceToken, ^{
        shareManager = [[LRHMTransformManager alloc] init];
    });
    return shareManager;
}

#pragma mark CGAffineTransform
- (CGAffineTransform)rotateTransformWith:(NSRect)rect withAngle:(CGFloat)angle
{
    return CGAffineTransformMakeRotation((angle *M_PI)/180);
}

- (CGAffineTransform)verticalFlipTransformWith:(NSRect)rect
{
    CGAffineTransform transfrom = CGAffineTransformIdentity;
    CGAffineTransform tTransform = CGAffineTransformMakeScale(1.0f, -1.0f);
    
    tTransform = CGAffineTransformTranslate(tTransform, 0.0, -NSHeight(rect));
    
    transfrom = CGAffineTransformConcat(transfrom, tTransform);
    return transfrom;
}

- (CGAffineTransform)horizontalFlipTransformWith:(NSRect)rect
{
    CGAffineTransform transfrom = CGAffineTransformIdentity;
    CGAffineTransform tTransform = CGAffineTransformMakeScale(-1.0f, 1.0f);
    
    tTransform = CGAffineTransformTranslate(tTransform, -NSWidth(rect), 0.0);
    transfrom = CGAffineTransformConcat(transfrom, tTransform);
    return transfrom;
}
@end
