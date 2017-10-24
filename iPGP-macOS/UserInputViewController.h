//
//  UserInputViewController.h
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class TADropView;

@interface UserInputViewController : NSViewController {
    IBOutlet NSTextView *_textView;
    IBOutlet NSTabView *_tabView;
    IBOutlet TADropView *_dropView;
}

- (nullable NSData *)userData;
- (BOOL)isFile;

- (void)setString:(nullable NSString *)string;

@end
