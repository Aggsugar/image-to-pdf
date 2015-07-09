//
//  LRHMIKImageBrowserView.m
//  ImageToPdf
//
//  Created by 蓝锐黑梦 on 15/3/31.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMIKImageBrowserView.h"

@implementation LRHMIKImageBrowserView

- (void)awakeFromNib
{
    NSImage *image = [NSImage imageNamed:@"centerLayer_tips"];
    CALayer *layer = [CALayer layer];
    layer.contents = image;
    
    [self setBackgroundLayer:layer];
}

-(void)keyDown:(NSEvent *)theEvent
{
    unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
    if (key == NSDeleteCharacter) {
        if ([[self selectionIndexes] count] ==  0) {
            NSBeep();
        }else{
            if ([[self delegate] conformsToProtocol:@protocol(LRHMIKImageBrowserViewDelegate)]) {
                if ([[self delegate] respondsToSelector:@selector(removeItems:imageBrowserView:)]) {
                    [[self delegate] removeItems:[self selectionIndexes] imageBrowserView:self];
                }
            }
        }
    }else if ([theEvent modifierFlags] & NSCommandKeyMask && [[[theEvent charactersIgnoringModifiers]lowercaseString]isEqualToString:@"a"])
    {
        [self selectAll:self];
    }
    else{
        
        [super keyDown:theEvent];
    }
}

-(void)mouseDragged:(NSEvent *)theEvent
{
//    _isDragged = YES;
    [super mouseDragged:theEvent];
}

-(void) mouseUp:(NSEvent *)theEvent
{
    //    [theEvent locationInWindow];
//    if(!(_isDragged || ([theEvent modifierFlags] & NSShiftKeyMask) || ([theEvent modifierFlags] & NSCommandKeyMask))){
//        NSPoint event_location = [theEvent locationInWindow];
//        NSPoint local_point = [self convertPoint:event_location fromView:nil];
//        NSInteger index = [self indexOfItemAtPoint:local_point];
//        if(index == NSNotFound){
//            //
//        }else{
//            if([[self selectionIndexes] containsIndex:index]){
//                NSRange range = {index,1};
//                NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
//                [self setSelectionIndexes:indexSet byExtendingSelection:NO];
//            }
//        }
//    }
//    _isDragged = NO;
    [super mouseUp:theEvent];
    
}

- (void)dealloc
{
    [super dealloc];
}



@end
