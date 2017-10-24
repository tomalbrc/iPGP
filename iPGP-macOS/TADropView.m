//
//  TADropView.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "TADropView.h"
#import <QuickLook/QuickLook.h>

@interface TADropView () {
}
@end

@implementation TADropView

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
    [super viewWillMoveToWindow:newWindow];
    
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
}


- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSPasteboard *pb = [sender draggingPasteboard];
    _fileURL = [NSURL URLWithString:[[pb propertyListForType:NSFilenamesPboardType] firstObject]];
    if (_fileURL) {
        imageView.image = [NSWorkspace.sharedWorkspace iconForFile:_fileURL.path];
        
        
        
        
        return YES;
    }
    return NO;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationGeneric;
}
- (BOOL)wantsPeriodicDraggingUpdates {
    return NO;
}

@end
