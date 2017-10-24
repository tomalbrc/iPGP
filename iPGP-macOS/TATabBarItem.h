//
//  TATabBarItem.h
//  iPGP-macOS
//
//  Created by Tom Albrecht on 05.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

IB_DESIGNABLE
@interface TATabBarItem : NSButton

@property (strong, nonatomic, nullable) IBInspectable NSColor *tintColor;
@property (strong, nonatomic, nullable) IBInspectable NSColor *defaultColor;

@end
