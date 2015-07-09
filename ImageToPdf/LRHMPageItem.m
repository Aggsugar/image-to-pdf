//
//  test.m
//  test1
//
//  Created by aggsugar on 15/3/31.
//  Copyright (c) 2015年 aggsugar. All rights reserved.
//

#import "LRHMPageItem.h"
#import <Quartz/Quartz.h>
@implementation LRHMPageItem
@synthesize identify;
@synthesize fileName;
@synthesize filePath;
@synthesize transform;

- (id)init
{
    self = [super init];
    if (self) {
        self.transform = CGAffineTransformIdentity;
        self.filePath = nil;
        self.identify = nil;
    }
    return self;
}

- (id)initWithFilepath:(NSString *)filepath
{
    self = [super init];
    if (self) {
        self.filePath = filepath;
        self.transform = CGAffineTransformIdentity;
        [self createIdentifyWith:filepath];
    }
    return self;
}

- (void)createIdentifyWith:(NSString *)filepath
{
    NSString *tIdentify = [[filepath lastPathComponent] stringByDeletingPathExtension];
    tIdentify = [NSString stringWithFormat:@"%@_%ld",tIdentify,random()];
    self.identify = tIdentify;
}

- (NSString *)fileName
{
    if (self.filePath) {
        return [[self.filePath lastPathComponent] stringByDeletingPathExtension];
    }
    return nil;
}

- (NSImage *)pageImage
{
    if (CGAffineTransformEqualToTransform(self.transform, CGAffineTransformIdentity)) {
        return [[[NSImage alloc] initWithContentsOfFile:self.filePath] autorelease];
    }
    CIImage *ciimage = [CIImage imageWithContentsOfURL:[NSURL fileURLWithPath:self.filePath]];
    CIImage *outputImage = [ciimage imageByApplyingTransform:self.transform];
    return [self ciimageToNSImage:outputImage];
}

//-(BOOL)saveImage:(NSImage *)img toDisk:(NSString *)savePath usingFormat:(NSString *)fmtDescription
//{
//    if (img != nil) {
//        NSData *imageData = [img TIFFRepresentation];
//        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
//        NSData *outData = [imageRep representationUsingType:NSPNGFileType
//                                                 properties:nil];
//        [outData writeToFile:savePath atomically:YES];
//        
//        return YES;
//    }
//    return NO;
//}

- (void)appendCGTransform:(CGAffineTransform)cgtransform
{
    self.transform = CGAffineTransformConcat(self.transform, cgtransform);
}
#pragma mark image convert
- (NSImage *)ciimageToNSImage:(CIImage *)image
{
//    image = [image imageByApplyingTransform:CGAffineTransformMakeTranslation(-NSMinX(image.extent), -NSMinY(image.extent))];
    NSImage *img = [[NSImage alloc] initWithSize:image.extent.size];
    [img lockFocus];
    [image drawInRect:NSMakeRect(0, 0, img.size.width, img.size.height) fromRect:image.extent operation:NSCompositeSourceOver fraction:1.f];
    [img unlockFocus];
    return [img autorelease];
    
    //此转换效率比上述高
//    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:image];
//    NSImage *nsImage = [[[NSImage alloc] initWithSize:rep.size] autorelease];
//    [nsImage addRepresentation:rep];
//    return nsImage;
}

- (CGImageRef)cgimageRef:(char *)filepath{
    CFStringRef cfString =  CFStringCreateWithCString(NULL,filepath, kCFStringEncodingUTF8);
    CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                                     cfString,
                                                     kCFURLPOSIXPathStyle,
                                                     false);
    CFRelease(cfString);
    CGImageSourceRef source = CGImageSourceCreateWithURL(fileURL, NULL);
    
    if(source == NULL)
    {
        CFRelease( fileURL );
        return NULL;
    }
    
    CGImageRef image = CGImageSourceCreateImageAtIndex(source,0,NULL);
    CFRelease( fileURL );
    CFRelease(source);
    return image;
}

- (CIImage *)NSImageToCIImage:(NSImage *)image
{
    CGImageRef cgimage = [image CGImageForProposedRect:nil
                                               context:nil hints:nil];
    CIImage *ciimage = [CIImage imageWithCGImage:cgimage];
    return ciimage;
}

#pragma mark ikimageItem Datasource
- (NSString *)imageUID
{
    return self.identify;
}

- (NSString *)imageRepresentationType
{
//    return IKImageBrowserCGImageRepresentationType;
    return IKImageBrowserNSImageRepresentationType;
}

- (id)imageRepresentation
{
    return [self pageImage];
}
@end
