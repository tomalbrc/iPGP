//
//  NSImage+Additions.h
//  iPGP-macOS
//
//  Created by Tom Albrecht on 05.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Additions)
- (NSImage *)tintedImageWithColor:(NSColor *)tint;
@end
