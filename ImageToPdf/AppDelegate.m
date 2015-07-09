//
//  AppDelegate.m
//  ImageToPdf
//
//  Created by 蓝锐黑梦 on 15/3/31.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "AppDelegate.h"
#import <Quartz/Quartz.h>
#import "LRHMTitleBar.h"
#import "LRHMPagesManager.h"
#import "LRHMTransformManager.h"
#import "LRHMPdfBaseInfoCtrl.h"
#import "LRHMExportTipsViewCtrl.h"

NSString *const anticlockwiseRotateBtnIdentify = @"anticlockwiseRotateIdentify";
NSString *const clockwiseRotateBtnIdentify = @"clockwiseRotateIdentify";
NSString *const horizontalBtnFlipIdentify = @"horizontalFlipIdentify";
NSString *const verticalBtnFlipIdentify = @"verticalFlipIdentify";
NSString *const exportBtnIdentify = @"exportBtnIdentify";
NSString *const IKBrowserViewDragIndexsType = @"browserViewDragIndexsType";

@interface AppDelegate ()
{
    LRHMPdfBaseInfoCtrl *_pdfInfoCtrl;
    LRHMExportTipsViewCtrl *_exportTipsView;
    IBOutlet NSScrollView  *_scrollView;
}
@property IBOutlet NSWindow *window;
@property (readwrite) BOOL isEnable;
@property (readwrite) BOOL isCanExport;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)awakeFromNib
{
    [[[self.window contentView] superview] setWantsLayer:YES];
//    [self initTitlebar];
    [self initImageBrowserViewInfo];
    [self initProgressTipsView];
    
    self.isEnable = NO;
    self.isCanExport = NO;
}

- (void)initProgressTipsView
{
    NSRect bound = [self.window.contentView bounds];
    [[self exportTipsViewCtrl].view setFrame:bound];
    
    [[self exportTipsViewCtrl].view setHidden:YES];
    [self.window.contentView addSubview:[self exportTipsViewCtrl].view positioned:NSWindowAbove relativeTo:_scrollView];
}

- (void)initImageBrowserViewInfo
{
    [_imageBrowserView setDraggingDestinationDelegate:self];
    [_imageBrowserView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, IKBrowserViewDragIndexsType,nil]];
    
//    [_imageBrowserView setAllowsDroppingOnItems:YES];
    [_imageBrowserView setAllowsReordering:YES];
    [_imageBrowserView setAnimates:YES];
    
    [_imageBrowserView setDataSource:self];
    [_imageBrowserView setDelegate:self];
    [_imageBrowserView setDraggingDestinationDelegate:self];
    [_imageBrowserView setAllowsMultipleSelection:YES];

}

- (LRHMPdfBaseInfoCtrl *)pdfBaseInfoCtrl
{
    if (!_pdfInfoCtrl) {
        _pdfInfoCtrl = [[LRHMPdfBaseInfoCtrl alloc] initWithNibName:@"LRHMPdfBaseInfoCtrl" bundle:nil];
    }
    return _pdfInfoCtrl;
}

- (LRHMExportTipsViewCtrl *)exportTipsViewCtrl
{
    if (!_exportTipsView) {
        _exportTipsView = [[LRHMExportTipsViewCtrl alloc] initWithNibName:@"LRHMExportTipsView" bundle:nil];
    }
    return _exportTipsView;
}

-(void) initTitlebar
{
    NSRect windowFrame = [NSWindow  frameRectForContentRect:[[self.window contentView] bounds] styleMask:[self.window styleMask]];
    NSRect contentBounds = [[self.window contentView] bounds];
    
    NSRect titlebarRect = NSMakeRect(0, 0, windowFrame.size.width, windowFrame.size.height - contentBounds.size.height);
    titlebarRect.origin.y = windowFrame.size.height - titlebarRect.size.height;
    
    LRHMTitleBar* titleBar = [[LRHMTitleBar alloc]initWithFrame:titlebarRect];
    [titleBar setAutoresizingMask:(NSViewWidthSizable | NSViewMinYMargin)];
    [titleBar setFillColor:[NSColor colorWithDeviceRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0f]];
    [titleBar setBorderColor:[NSColor colorWithDeviceRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0f]];
    [titleBar setTitleColor:[NSColor whiteColor]];
    
    [[[self.window contentView] superview] addSubview:titleBar positioned:NSWindowBelow relativeTo:[[[[self.window contentView] superview] subviews] objectAtIndex:0]];
}


#pragma mark ikimagebrowserView datasource
- (NSUInteger)numberOfItemsInImageBrowser:(IKImageBrowserView *)aBrowser
{
    return [[LRHMPagesManager shareImagesManager] pageImageCount];
}

- (id)imageBrowser:(IKImageBrowserView *)aBrowser
       itemAtIndex:(NSUInteger)index
{
    return [[LRHMPagesManager shareImagesManager] pageItemAt:index];
}

- (BOOL)imageBrowser:(IKImageBrowserView *)aBrowser
  moveItemsAtIndexes:(NSIndexSet *)indexes
             toIndex:(NSUInteger)destinationIndex
{
    NSInteger       index;
    NSMutableArray* temporaryArray;
    
    temporaryArray = [[[NSMutableArray alloc] init] autorelease];
    
    // First remove items from the data source and keep them in a temporary array.
    for (index = [indexes lastIndex]; index != NSNotFound; index = [indexes indexLessThanIndex:index])
    {
        if (index < destinationIndex)
            destinationIndex --;
        
        id obj = [[LRHMPagesManager shareImagesManager] pageItemAt:index];
        [temporaryArray addObject:obj];
        [[LRHMPagesManager shareImagesManager] removePageItemAt:index];
    }
    
    // Then insert the removed items at the appropriate location.
    NSInteger n = [temporaryArray count];
    for (index = 0; index < n; index++)
    {
        [[LRHMPagesManager shareImagesManager] insertPageItem:[temporaryArray objectAtIndex:index] atIndex:destinationIndex];
    }
    return YES;
}


- (NSUInteger) imageBrowser:(IKImageBrowserView *) aBrowser writeItemsAtIndexes:(NSIndexSet *) itemIndexes toPasteboard:(NSPasteboard *)pasteboard
{
    [pasteboard clearContents];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:itemIndexes];
    [pasteboard setData:data forType:IKBrowserViewDragIndexsType];
    return 3;//[itemIndexes count];
}

#pragma mark ikimagebrowserView delegate
- (void)imageBrowserSelectionDidChange:(IKImageBrowserView *)aBrowser
{
    if ([[aBrowser selectionIndexes] count] == 0) {
        self.isEnable = NO;
    }else{
        self.isEnable = YES;
    }
}

#pragma mark action
- (IBAction)loadPageImages:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel setAllowedFileTypes:[[LRHMPagesManager shareImagesManager] supportImageTypes]];
   [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
       if (result == NSOKButton) {
           NSArray *urls = [openPanel URLs];
           [self loadPageItemImagesWithUrls:urls];
           [self setExportBtnEnable:[self hasItemsInBrowserView]];
           [self replaceBrowserBackgroundLayer];
           [_imageBrowserView reloadData];
       }
   }];
}

- (void)loadPageItemImagesWithPaths:(NSArray *)filePaths
{
    for (NSString *filePath in filePaths) {
        [self loadPageImageWith:filePath];
    }
}

- (void)loadPageItemImagesWithUrls:(NSArray *)urls
{
    for (NSURL *url in urls) {
        [self loadPageImageWith:[url path]];
    }
}

- (void)loadPageImageWith:(NSString *)filePath
{
    BOOL isDir;
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir])
    {
        if (!isDir) {
            NSString *ext = [[filePath pathExtension] lowercaseString];
            if ([[[LRHMPagesManager shareImagesManager] supportImageTypes] containsObject:ext]) {
                [[LRHMPagesManager shareImagesManager] addPageItemWith:filePath];
            }
        }
    }
}

- (IBAction)imageAction:(id)sender
{
    if ([[sender identifier] isEqualToString:anticlockwiseRotateBtnIdentify]) {
     //逆时针旋转
        [self imageAnticlockwiseRotate];
    }
    
    if ([[sender identifier] isEqualToString:clockwiseRotateBtnIdentify]) {
    //顺时针旋转
        [self imageClockwiseRotate];
    }
    
    if ([[sender identifier] isEqualToString:horizontalBtnFlipIdentify]) {
    //水平翻转
        [self imageHorizontalFlip];
    }
    
    if ([[sender identifier] isEqualToString:verticalBtnFlipIdentify]) {
    //垂直翻转
        [self imageVerticalFlip];
    }
    
   
    [_imageBrowserView reloadData];
}

#pragma mark affineTransform
- (void)imageAnticlockwiseRotate
{
    NSIndexSet *indexs = [_imageBrowserView selectionIndexes];
    CGAffineTransform transform = [[LRHMTransformManager shareTransformManager] rotateTransformWith:NSZeroRect withAngle:90];
    [indexs enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [[LRHMPagesManager shareImagesManager] appendTransform:transform atPageItem:idx];
        [[LRHMPagesManager shareImagesManager] autoReloadPageItemIdentifyAt:idx];
    }];
}

- (void)imageClockwiseRotate
{
    NSIndexSet *indexs = [_imageBrowserView selectionIndexes];
    CGAffineTransform transform = [[LRHMTransformManager shareTransformManager] rotateTransformWith:NSZeroRect withAngle:-90];
    [indexs enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [[LRHMPagesManager shareImagesManager] appendTransform:transform atPageItem:idx];
        [[LRHMPagesManager shareImagesManager] autoReloadPageItemIdentifyAt:idx];
    }];
}

- (void)imageHorizontalFlip
{
    NSIndexSet *indexs = [_imageBrowserView selectionIndexes];
    
    [indexs enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSSize size = [[LRHMPagesManager shareImagesManager] pageImageAt:idx].size;
        NSRect rect = NSMakeRect(0, 0, (int)size.width, (int)size.height);
        CGAffineTransform transform = [[LRHMTransformManager shareTransformManager] horizontalFlipTransformWith:rect];
        [[LRHMPagesManager shareImagesManager] appendTransform:transform atPageItem:idx];
        [[LRHMPagesManager shareImagesManager] autoReloadPageItemIdentifyAt:idx];
    }];
}

- (void)imageVerticalFlip
{
    NSIndexSet *indexs = [_imageBrowserView selectionIndexes];
    
    [indexs enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSSize size = [[LRHMPagesManager shareImagesManager] pageImageAt:idx].size;
        NSRect rect = NSMakeRect(0, 0, (int)size.width, (int)size.height);
        CGAffineTransform transform = [[LRHMTransformManager shareTransformManager] verticalFlipTransformWith:rect];
        [[LRHMPagesManager shareImagesManager] appendTransform:transform atPageItem:idx];
        [[LRHMPagesManager shareImagesManager] autoReloadPageItemIdentifyAt:idx];
    }];
}

#pragma mark export
- (IBAction)exportPdf:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setCanCreateDirectories:YES];
    [openPanel setPrompt:@"Save"];
    [openPanel setAccessoryView:[self pdfBaseInfoCtrl].view];
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSOKButton) {
            NSString *path = [[openPanel URL] path];
            path = [[path stringByAppendingPathComponent:[self pdfBaseInfoCtrl].pdfFileName] stringByAppendingPathExtension:@"pdf"];
            [self performSelectorOnMainThread:@selector(setExportTipsViewHidden:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:YES];
            [self performSelectorInBackground:@selector(exportPdfTo:) withObject:path];
        }
    }];
}

- (void)setExportTipsViewHidden:(NSNumber *)booNum
{
    [[self exportTipsViewCtrl].view setHidden:[booNum boolValue]];
}

- (BOOL)exportPdfTo:(NSString *)savePath
{
    BOOL isSucceed = NO;
    PDFDocument *pdf = [[PDFDocument alloc] init];
    
    for (NSInteger pageCount = 0;pageCount < [[LRHMPagesManager shareImagesManager] pageImageCount];pageCount++)
    {
        PDFPage *page = [[PDFPage alloc] initWithImage:[[LRHMPagesManager shareImagesManager] pageImageAt:pageCount]];
        [pdf insertPage:page atIndex: [pdf pageCount]];
        [page release];
    
        [self postProgress:pageCount withTotalIndex:[[LRHMPagesManager shareImagesManager] pageImageCount]];
    }
    
    isSucceed = [pdf writeToFile:savePath];
 
    [self postProgress:[[LRHMPagesManager shareImagesManager] pageImageCount] withTotalIndex:[[LRHMPagesManager shareImagesManager] pageImageCount]];
    [pdf release];
    
    [self performSelectorOnMainThread:@selector(setExportTipsViewHidden:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    if (isSucceed) {
        [self viewFileAtFinder:savePath];
    }
   
    return isSucceed;
}

- (void)postProgress:(NSInteger)progressIndex withTotalIndex:(NSInteger)totalIndex
{
    NSDictionary *progressInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:progressIndex],kLRHMProgressIndex,[NSNumber numberWithInteger:totalIndex],kLRHMProgressTotalIndex, nil];
    [self performSelectorOnMainThread:@selector(postProgressNotification:) withObject:progressInfo waitUntilDone:YES];
}

- (void)postProgressNotification:(NSDictionary *)obj
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LRHMExportProgressNotification object:obj];
}

-(void)viewFileAtFinder:(NSString *)fileName
{
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    NSURL *url = [NSURL fileURLWithPath:fileName];
    [workspace activateFileViewerSelectingURLs:[NSArray arrayWithObject:url]];
}

#pragma mark ikimagebrowser custom delegate
-(BOOL)removeItems:(NSIndexSet *)indexs imageBrowserView:(LRHMIKImageBrowserView *)sender
{
    for (NSInteger tindex = [indexs lastIndex]; tindex != NSNotFound; tindex = [indexs indexLessThanIndex:tindex])
    {
        [[LRHMPagesManager shareImagesManager] removePageItemAt:tindex];
    }
    [self replaceBrowserBackgroundLayer];
    [self setExportBtnEnable:[self hasItemsInBrowserView]];
    [_imageBrowserView reloadData];
    return YES;
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    NSArray *list = [pboard propertyListForType:NSFilenamesPboardType];
    for (NSString *filePath in list) {
        NSString *ext = [[filePath pathExtension] lowercaseString];
        if ([[[LRHMPagesManager shareImagesManager] supportImageTypes] containsObject:ext]) {
            return NSDragOperationCopy;
        }
    }
    if([[pboard types] containsObject:IKBrowserViewDragIndexsType])
    {
        return NSDragOperationMove;
    }
   
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSData *data = nil;
    NSString *errorDescription;
    
    NSPasteboard *pasteboard = [sender draggingPasteboard];
    
    /* look for paths in pasteboard */
    if ([[pasteboard types] containsObject:NSFilenamesPboardType])
        data = [pasteboard dataForType:NSFilenamesPboardType];
    
    if (data)
    {
        /* retrieves paths */
        NSArray *filenames = [NSPropertyListSerialization propertyListFromData:data
                                                              mutabilityOption:NSPropertyListImmutable
                                                                        format:nil
                                                              errorDescription:&errorDescription];
        /* add paths to our datasource */
        [self loadPageItemImagesWithPaths:filenames];
        
        [self replaceBrowserBackgroundLayer];
        [self setExportBtnEnable:[self hasItemsInBrowserView]];
        [_imageBrowserView reloadData];
    }
        return YES;
}

- (BOOL)hasItemsInBrowserView
{
    if ([[LRHMPagesManager shareImagesManager] pageImageCount] == 0) {
        return NO;
    }
    return YES;
}

- (void)setExportBtnEnable:(BOOL)enable
{
    self.isCanExport = [self hasItemsInBrowserView];
}

- (void)replaceBrowserBackgroundLayer
{
    CALayer *layer = [CALayer layer];
    if ([self hasItemsInBrowserView]) {
        layer.contents = [NSImage imageNamed:@"centerLayer"];
        
        if (![((NSImage *)[[_imageBrowserView backgroundLayer] contents]).name isEqualToString:@"centerLayer"]) {
            [_imageBrowserView setBackgroundLayer:layer];
        }
    }else{
        layer.contents = [NSImage imageNamed:@"centerLayer_tips"];
        
        if (![((NSImage *)[[_imageBrowserView backgroundLayer] contents]).name isEqualToString:@"centerLayer_tips"]) {
            [_imageBrowserView setBackgroundLayer:layer];
        }
    }
   
    
}
#pragma mark dealloc
- (void)dealloc
{
    [super dealloc];
    if (_pdfInfoCtrl) {
        [_pdfInfoCtrl release];
        _pdfInfoCtrl = nil;
    }
    
    if (_imageBrowserView) {
        [_imageBrowserView release];
        _imageBrowserView = nil;
    }
}
@end
