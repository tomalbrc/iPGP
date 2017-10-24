//
//  DecryptViewController.h
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DecryptViewController : NSViewController {
    IBOutlet NSSecureTextField *_passwordTextField;
    IBOutlet NSButton *_savePasswordCheckBox;
}

- (IBAction)decrypt:(id)sender;

@end
