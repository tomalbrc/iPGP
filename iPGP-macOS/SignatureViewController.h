//
//  SignatureViewController.h
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SignatureViewController : NSViewController <NSTextViewDelegate> {
    IBOutlet NSTextField *_statusTextField;
}

@end
