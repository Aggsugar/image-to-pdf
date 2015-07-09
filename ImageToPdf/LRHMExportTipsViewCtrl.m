//
//  LRHMExportTipsView.m
//  ImageToPdf
//
//  Created by aggsugar on 15/4/2.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMExportTipsViewCtrl.h"
NSString *const  LRHMExportProgressNotification = @"ExportProgressNotification";
NSString *const  kLRHMProgressIndex = @"ProgressIndex";
NSString *const  kLRHMProgressTotalIndex = @"ProgressTotalIndex";

@interface LRHMExportTipsViewCtrl ()

@end

@implementation LRHMExportTipsViewCtrl

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:LRHMExportProgressNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:self.view];
    
   // [_progressIndicator setMaxValue:1.0f];
  //  [_progressIndicator setMinValue:0.0f];
  //  [_progressIndicator setDoubleValue:0.0f];
    [_progressIndicator startAnimation:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}


- (void)updateProgress:(NSNotification *)obj
{
    NSDictionary *dic = [obj object];
    NSInteger progressIndex = [[dic objectForKey:kLRHMProgressIndex] integerValue];
    NSInteger progressTotal = [[dic objectForKey:kLRHMProgressTotalIndex] integerValue];
    
    CGFloat progress = (progressIndex*1.0f) / progressTotal;
    NSString *labelProgress = [[NSString stringWithFormat:@"%d",(int)(progress*100)] stringByAppendingString:@"%"];
    [_percentField setStringValue:labelProgress];
   // [_progressIndicator setDoubleValue:progress];
}

- (void)viewFrameChanged:(NSNotification *)notification
{
    NSRect centerViewFrame = _centerView.frame;
    centerViewFrame.origin.x = (NSWidth(self.view.frame) - NSWidth(centerViewFrame)) / 2.0f;
    centerViewFrame.origin.y = (NSHeight(self.view.frame) - NSHeight(centerViewFrame)) / 2.0f;
    [_centerView setFrame:centerViewFrame];
}
@end
