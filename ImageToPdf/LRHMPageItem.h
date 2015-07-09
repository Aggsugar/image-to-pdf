//
//  test.h
//  test1
//
//  Created by aggsugar on 15/3/31.
//  Copyright (c) 2015年 aggsugar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LRHMPageItem : NSObject
@property (readwrite,copy)  NSString * identify;
@property (readwrite,copy)  NSString *filePath;
@property (readonly) NSString * fileName;
@property (assign) CGAffineTransform transform;

- (id)initWithFilepath:(NSString *)filepath;
- (NSImage *)pageImage;
- (void)appendCGTransform:(CGAffineTransform)cgtransform;
@end
