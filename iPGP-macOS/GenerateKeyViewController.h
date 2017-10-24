//
//  GenerateKeyViewController.h
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class PGPKey;

@class GenerateKeyViewController;
@protocol GenerateKeyViewControllerDelegate
- (void)generateKeyViewController:(GenerateKeyViewController *)generateKeyViewController didFinishWithKeys:(NSArray<PGPKey *> *)keys;
@end

@interface GenerateKeyViewController : NSViewController <WKScriptMessageHandler> {
    IBOutlet NSPopUpButton *keyLengthSelection;
    IBOutlet NSPopUpButton *algoSelection;
    
    IBOutlet NSTextField *nameLabel;
    IBOutlet NSTextField *emailLabel;
    IBOutlet NSTextField *passwordLabel;
    IBOutlet NSTextField *passwordVerifyLabel;

    
    IBOutlet NSTextField *nameTF;
    IBOutlet NSTextField *emailTF;
    IBOutlet NSTextField *commentTF;
    IBOutlet NSSecureTextField *passwordTF;
    IBOutlet NSSecureTextField *passwordConfirmTF;
}

@property (weak, nonatomic) id<GenerateKeyViewControllerDelegate> delegate;

- (IBAction)generate:(id)sender;

@end
