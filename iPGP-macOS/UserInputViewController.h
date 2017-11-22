//
//  UserInputViewController.h
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class TADropView;

@interface UserInputViewController : NSViewController {
    IBOutlet NSTabView *_tabView;
    IBOutlet TADropView *_dropView;
}

@property (nonatomic, nonnull) IBOutlet NSTextView *textView;

- (nullable NSData *)userData;
- (BOOL)isFile;

@end
