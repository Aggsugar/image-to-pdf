//
//  LRHMExportTipsView.h
//  ImageToPdf
//
//  Created by aggsugar on 15/4/2.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LRHMExportTipsView;
extern  NSString *const  LRHMExportProgressNotification;
extern  NSString *const  kLRHMProgressIndex;
extern  NSString *const  kLRHMProgressTotalIndex;
@interface LRHMExportTipsViewCtrl : NSViewController
{
    IBOutlet NSTextField   *_percentField;
    IBOutlet NSProgressIndicator *_progressIndicator;
    IBOutlet NSView  * _centerView;
}
@end
