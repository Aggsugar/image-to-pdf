//
//  testManager.h
//  test1
//
//  Created by aggsugar on 15/3/31.
//  Copyright (c) 2015年 aggsugar. All rights reserved.
//

//@"jpg",@"cur"@"bmp",@"jpeg",@"gif",@"png",@"tiff",@"tif",/*@"pic",*/@"ico",@"icns",@"tga",@"psd",@"eps","hdr“,@"jp2",@"jpc",@"pict",@"sgi'

#import <Foundation/Foundation.h>
@class LRHMPageItem;
@interface LRHMPagesManager : NSObject
{
    NSMutableArray   *_imageList;
}
@property (readonly) NSArray *supportImageTypes;

+ (LRHMPagesManager *)shareImagesManager;

- (void)addPageItemWith:(NSString *)filePath;
- (NSInteger)pageImageCount;

- (NSImage *)pageImageAt:(NSInteger)index;
- (void)appendTransform:(CGAffineTransform)transform atPageItem:(NSInteger)index;
- (LRHMPageItem *)pageItemAt:(NSInteger)index;
- (void)autoReloadPageItemIdentifyAt:(NSInteger)index;
- (void)removePageItemAt:(NSInteger)index;

- (void)insertPageItem:(LRHMPageItem *)pageItem atIndex:(NSInteger)index;
@end
