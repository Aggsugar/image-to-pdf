//
//  LRHMPdfBaseInfo.m
//  test1
//
//  Created by aggsugar on 15/3/31.
//  Copyright (c) 2015年 aggsugar. All rights reserved.
//

#import "LRHMPdfBaseInfoCtrl.h"

@interface LRHMPdfBaseInfoCtrl ()

@end

@implementation LRHMPdfBaseInfoCtrl
{
    NSString *_pdfFileName;
}
@synthesize pdfFileName = _pdfFileName;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)dealloc
{
    [super dealloc];
    if (_pdfFileName) {
        [_pdfFileName release];
        _pdfFileName = nil;
    }
}

- (NSString *)pdfFileName
{
   // [[self.view window] makeFirstResponder:nil];
    if (!_pdfFileName) {
        return @"Untitled";
    }
    return _pdfFileName;
}
@end
