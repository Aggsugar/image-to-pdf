//
//  AppDelegate.h
//  ImageToPdf
//
//  Created by 蓝锐黑梦 on 15/3/31.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LRHMIKImageBrowserView.h"
@interface AppDelegate : NSObject <NSApplicationDelegate,LRHMIKImageBrowserViewDelegate>
{
    IBOutlet LRHMIKImageBrowserView * _imageBrowserView;
}

@end

