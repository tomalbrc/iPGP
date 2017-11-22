//
//  TADropView.h
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TADropView : NSView <NSDraggingDestination> {
    IBOutlet NSImageView *imageView;
    IBOutlet NSTextField *filenameLabel;
    IBOutlet NSTextField *filesizeLabel;
    IBOutlet NSTextField *fileCreationDateLabel;
    IBOutlet NSTextField *fileModificationDateLabel;
}

@property (strong, nonatomic, nullable) NSURL *fileURL;

@end
