//
//  TATabBarItem.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 05.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "TATabBarItem.h"
#import "NSImage+Additions.h"

@implementation TATabBarItem

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        
    }
    return self;
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    
    self.focusRingType = NSFocusRingTypeNone;
    
    NSFont *lblFont = [NSFont systemFontOfSize:14.f];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.alternateTitle
                                                              attributes:@{NSForegroundColorAttributeName:self.tintColor, NSFontAttributeName:lblFont}];
    self.attributedAlternateTitle = str;
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:self.title attributes:@{NSForegroundColorAttributeName:self.defaultColor, NSFontAttributeName:lblFont}];
    self.attributedTitle = str2;
    
    self.image = [self.image tintedImageWithColor:self.defaultColor];
    self.alternateImage = [self.alternateImage tintedImageWithColor:self.tintColor];
    self.layer.backgroundColor = [NSColor greenColor].CGColor;
    
    self.allowsMixedState = NO;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    NSLog(@"%s %d", __PRETTY_FUNCTION__, highlighted);
}

- (void)setState:(NSControlStateValue)state {
    [super setState:state];
    NSLog(@"%s: %ld", __PRETTY_FUNCTION__, (long)state);
    /*
    BOOL isOn = state == NSControlStateValueOn;
    if (isOn && self.alternateTitle) {
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.alternateTitle attributes:@{NSForegroundColorAttributeName:self.tintColor}];
        self.attributedAlternateTitle = str;
        
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:self.title attributes:@{NSForegroundColorAttributeName:self.defaultColor}];
        self.attributedTitle = str2;
        
        self.image = [self.image tintedImageWithColor:self.defaultColor];
        self.alternateImage = [self.alternateImage tintedImageWithColor:self.tintColor];

    } else if (self.title) {
        
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.alternateTitle attributes:@{NSForegroundColorAttributeName:self.defaultColor}];
        self.attributedAlternateTitle = str;
        
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:self.title attributes:@{NSForegroundColorAttributeName:self.defaultColor}];
        self.attributedTitle = str2;
        
        self.image = [self.image tintedImageWithColor:self.defaultColor];
        self.alternateImage = [self.alternateImage tintedImageWithColor:self.defaultColor];
    }
    */

}



@end
