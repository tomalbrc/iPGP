//
//  EncryptViewController.h
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EncryptViewController : NSViewController <NSTokenFieldDelegate, NSOpenSavePanelDelegate> {
    IBOutlet NSTokenField *_recipientTokenField;
    IBOutlet NSPopUpButton *_signeeSelection;
    IBOutlet NSTextField *_signeeLbl;

    IBOutlet NSButton *_saveFileCheckBox;
    IBOutlet NSButton *_signCheckBox;
    
    IBOutlet NSTextField *_passwordLbl;
    IBOutlet NSSecureTextField *_passwordTextField;
}

- (IBAction)encrypt:(id)sender;

- (IBAction)switchSignBox:(id)sender;

@end
