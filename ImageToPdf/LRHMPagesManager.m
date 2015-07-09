//
//  testManager.m
//  test1
//
//  Created by aggsugar on 15/3/31.
//  Copyright (c) 2015年 aggsugar. All rights reserved.
//

#import "LRHMPagesManager.h"
#import "LRHMPageItem.h"
@implementation LRHMPagesManager
@synthesize supportImageTypes;
- (NSArray *)supportImageTypes
{
    return [NSArray arrayWithObjects:@"jpg",@"cur",@"bmp",@"jpeg",@"gif",@"png",@"tiff",@"tif",/*@"pic",*/@"ico",@"icns",@"tga",@"psd",@"eps",@"hdr",@"jp2",@"jpc",@"pict",@"sgi", nil];
}

- (void)ensureCreateImageList
{
    if (!_imageList) {
        _imageList = [[NSMutableArray alloc] init];
    }
}

+ (LRHMPagesManager *)shareImagesManager
{
    static dispatch_once_t onceToken;
    static LRHMPagesManager *shareManager = nil;
   dispatch_once(&onceToken, ^{
       shareManager = [[LRHMPagesManager alloc] init];
   });
    return shareManager;
}

- (void)addPageItemWith:(NSString *)filePath
{
    LRHMPageItem *pageItem = [[LRHMPageItem alloc] initWithFilepath:filePath];
    
    [self ensureCreateImageList];
    [_imageList addObject:pageItem];
    [pageItem release];
}

- (NSImage *)pageImageAt:(NSInteger)index
{
    if ((index >= 0) && (index < [self pageImageCount])) {
        return [[_imageList objectAtIndex:index] pageImage];
    }
    return nil;
}

- (LRHMPageItem *)pageItemAt:(NSInteger)index
{
    if ((index >= 0) && (index < [self pageImageCount])) {
        return [_imageList objectAtIndex:index];
    }
    return nil;
}

- (void)removePageItemAt:(NSInteger)index
{
    if ((index >= 0) && (index <[self pageImageCount])) {
        [_imageList removeObjectAtIndex:index];
    }
}

- (void)insertPageItem:(LRHMPageItem *)pageItem atIndex:(NSInteger)index
{
    if (((index >= 0) && (index < [self pageImageCount])) && pageItem) {
        [_imageList insertObject:pageItem atIndex:index];
    }
}

- (NSInteger)pageImageCount
{
    return [_imageList count];
}

- (void)appendTransform:(CGAffineTransform)transform atPageItem:(NSInteger)index
{
    if ((index >= 0) && index < [self pageImageCount]) {
        [[_imageList objectAtIndex:index] appendCGTransform:transform];
    }
}

- (void)autoReloadPageItemIdentifyAt:(NSInteger)index
{
    if ((index >= 0) && index < [self pageImageCount]) {
        NSString *tIdentify = [[_imageList objectAtIndex:index] identify];
        tIdentify = [NSString stringWithFormat:@"%@_1",tIdentify];
        [[_imageList objectAtIndex:index] setIdentify:tIdentify];
    }
}
@end
