//
//  TAImageLabelTableCellView.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "TAImageLabelTableCellView.h"
#import "NSImage+Additions.h"
#import "NSColor+Additions.h"

@implementation TAImageLabelTableCellView

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
