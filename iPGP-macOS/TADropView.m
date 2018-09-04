//
//  TADropView.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "TADropView.h"
#import <QuickLook/QuickLook.h>

@interface TADropView () {
    /**
     * Used for drawing the background when hover-dragging items over the view as indicator
     */
    BOOL drawDragBackground;
    /**
     * Color the drag background red when the drag is not valid
     */
    BOOL validFile;
}
@end

@implementation TADropView

- (BOOL)canBecomeKeyView {
    return YES;
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
    [super viewWillMoveToWindow:newWindow];
    
    if (!_fileURL) {
        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
        
        [imageView unregisterDraggedTypes];
        
        drawDragBackground = NO;
        validFile = NO;
        
        filenameLabel.stringValue = @"No file selected";
        filesizeLabel.stringValue = @"";
        fileCreationDateLabel.stringValue = @"";
        fileModificationDateLabel.stringValue = @"Drag and drop a file here";
    }
}

#pragma mark - Drag n Drop Support

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    drawDragBackground = YES;
    [self setNeedsDisplay:YES];

    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    drawDragBackground = NO;
    [self setNeedsDisplay:YES];

    NSPasteboard *pb = [sender draggingPasteboard];
    NSArray *pbres = [pb propertyListForType:NSFilenamesPboardType];
    if (pbres.count > 1)
        return NO;
    
    
    NSArray *files = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    
    NSError *error;
    NSDictionary *attributes = [NSFileManager.defaultManager attributesOfItemAtPath:files.firstObject error:&error];
    NSLog(@"Attribute: %@", attributes[NSFileType]);
    if (!error && [attributes[NSFileType] isEqualToString:NSFileTypeRegular]) {
        self.fileURL = [NSURL fileURLWithPath:files.firstObject];
        return YES;
    }
    return NO;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    NSArray *files = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    
    NSError *error;
    NSDictionary *attributes = [NSFileManager.defaultManager attributesOfItemAtPath:files.firstObject error:&error];

    if (files.count > 1 || ![attributes[NSFileType] isEqualToString:NSFileTypeRegular] || error) {
        validFile = NO;
    } else validFile = YES;
    
    drawDragBackground = YES;
    [self setNeedsDisplay:YES];
    
    return NSDragOperationGeneric;
}
- (void)draggingExited:(id<NSDraggingInfo>)sender {
    drawDragBackground = NO;
    [self setNeedsDisplay:YES];

}

- (BOOL)wantsPeriodicDraggingUpdates {
    return NO;
}


#pragma mark - Setter

- (void)setFileURL:(NSURL *)fileURL {
    _fileURL = fileURL;
    
    NSError *error;
    NSDictionary *attributes = [NSFileManager.defaultManager attributesOfItemAtPath:_fileURL.path error:&error];
    if (!error && [attributes[NSFileType] isEqualToString:NSFileTypeRegular]) {
        imageView.image = [NSWorkspace.sharedWorkspace iconForFile:_fileURL.path];
        imageView.image.size = NSMakeSize(96, 96);
        
        filenameLabel.stringValue = _fileURL.path.lastPathComponent;
        
        NSString *fs = [NSByteCountFormatter stringFromByteCount:[attributes[NSFileSize] longLongValue] countStyle:NSByteCountFormatterCountStyleFile];
        filesizeLabel.stringValue = [NSString stringWithFormat:@"%@", fs];
        
        NSDate *cd = attributes[NSFileCreationDate];
        NSDate *md = attributes[NSFileModificationDate];
        
        NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
        [dfm setLocale:[NSLocale currentLocale]];
        [dfm setDateFormat:@"dd.MM.YYYY, HH:mm"];
        
        fileCreationDateLabel.stringValue = [dfm stringFromDate:cd];
        fileModificationDateLabel.stringValue = [dfm stringFromDate:md];
    }
}

#pragma mark - Drawing Code

- (void)drawRect:(NSRect)dirtyRect {
    if (drawDragBackground) {
        CGFloat padding = 2.f;
        
        NSColor *baseColor = validFile ? NSColor.greenColor : NSColor.redColor;
        
        NSBezierPath* rectanglePath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(dirtyRect.origin.x+padding, dirtyRect.origin.y+padding, dirtyRect.size.width-padding*2, dirtyRect.size.height-padding*2) xRadius: 31 yRadius: 31];
        [[baseColor colorWithAlphaComponent:.25f] setFill];
        [rectanglePath fill];
        
        [baseColor setStroke];
        [rectanglePath setLineWidth:1.f];
        [rectanglePath stroke];
    }
    
}

@end
