//
//  LRHMExportTipsView.m
//  ImageToPdf
//
//  Created by aggsugar on 15/4/2.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMExportTipsView.h"

@implementation LRHMExportTipsView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [[NSColor colorWithDeviceWhite:0.7 alpha:0.7] set];
    NSRectFill(self.bounds);
}

- (void)awakeFromNib
{
}

- (void)mouseDown:(NSEvent *)theEvent
{
    
}

@end
