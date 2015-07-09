//
//  LRHMIKImageBrowserView.h
//  ImageToPdf
//
//  Created by 蓝锐黑梦 on 15/3/31.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Quartz/Quartz.h>
@class LRHMIKImageBrowserView;
@protocol LRHMIKImageBrowserViewDelegate<NSObject>
-(BOOL)removeItems:(NSIndexSet *)indexs imageBrowserView:(LRHMIKImageBrowserView *)sender;
@end
@interface LRHMIKImageBrowserView : IKImageBrowserView

@end
