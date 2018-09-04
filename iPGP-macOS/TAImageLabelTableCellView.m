//
//  TAImageLabelTableCellView.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "TAImageLabelTableCellView.h"
#import "NSImage+Additions.h"
#import "NSColor+Additions.h"

@implementation TAImageLabelTableCellView

- (NSMenu *)menuForEvent:(NSEvent *)event {
    NSMenu *menu = NULL;
    if (event.type == NSLeftMouseDown || event.type == NSRightMouseDown || 1) {
        menu = [[NSMenu alloc] initWithTitle:@"Cell"];
        [menu addItem:[[NSMenuItem alloc] initWithTitle:@"dsadsa" action:0 keyEquivalent:@" "]];
        return menu;
    }
    return menu;
}

- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle {
    if (backgroundStyle == NSBackgroundStyleDark) {
        labelImageView.image = [labelImageView.image tintedImageWithColor:[NSColor whiteColor]];
        label.textColor = [NSColor whiteColor];
    } else {
        labelImageView.image = [labelImageView.image tintedImageWithColor:[NSColor purpleUrple]];
        label.textColor = [NSColor purpleUrple];
    }
}

@end
