//
//  LRHMContentView.m
//  ImageToPdf
//
//  Created by 蓝锐黑梦 on 15/3/31.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMContentView.h"

@implementation LRHMContentView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[NSColor colorWithDeviceRed:56.0/255 green:56.0/255 blue:56.0/255 alpha:1.0]set];
    NSRectFill(self.bounds);
    // Drawing code here.
}

@end
