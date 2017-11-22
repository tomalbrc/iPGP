//
//  NSImage+Additions.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 05.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "NSImage+Additions.h"

@implementation NSImage (Additions)
- (NSImage *)tintedImageWithColor:(NSColor *)tint {
    NSImage *image = [self copy];
    if (tint) {
        [image lockFocus];
        [tint set];
        NSRect imageRect = {NSZeroPoint, image.size};
        NSRectFillUsingOperation(imageRect, NSCompositingOperationSourceAtop);
        [image unlockFocus];
    }
    image.template = NO;
    return image;
}
@end
