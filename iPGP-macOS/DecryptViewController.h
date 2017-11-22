//
//  DecryptViewController.h
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DecryptViewController : NSViewController <NSTextViewDelegate> {
    IBOutlet NSSecureTextField *_passwordTextField;
    IBOutlet NSButton *_savePasswordCheckBox;
    
    IBOutlet NSPopUpButton *_recipientSelection;
}

- (IBAction)decrypt:(id)sender;

@end
