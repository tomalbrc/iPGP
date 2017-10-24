//
//  TADropView.h
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TADropView : NSView <NSDraggingDestination> {
    IBOutlet NSImageView *imageView;
    IBOutlet NSTextField *filenameLabel;
    IBOutlet NSTextField *filesizeLabel;
}

@property (strong, nonatomic, nullable) NSURL *fileURL;

@end
