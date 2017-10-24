//
//  EncryptViewController.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "EncryptViewController.h"

#import "XApplication+Additions.h"
#import "UserInputViewController.h"

@interface EncryptViewController () {
    UserInputViewController *_userInputViewController;
}

@end

@implementation EncryptViewController

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationController isKindOfClass:[UserInputViewController class]])
        _userInputViewController = (UserInputViewController *)segue.destinationController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _textView.string = @"";
    [self switchSignBox:_signeeSelection];
}

- (IBAction)encrypt:(id)sender {
    NSArray<PGPKey *> *keys = [_recipientTokenField objectValue];
    if (_userInputViewController && keys.count) {
        NSError *error;
        NSData *res;
        if (_signCheckBox.state == NSControlStateValueOn) {
            res = [[NSApplication.sharedApplication objectivePGP] encryptData:_userInputViewController.userData usingPublicKeys:keys signWithSecretKey:PGPKeys[0] passphrase:_passwordTextField.stringValue armored:YES error:&error];
        } else {
            NSData *data = _userInputViewController.userData;
            res = [[NSApplication.sharedApplication objectivePGP] encryptData:data usingPublicKeys:keys armored:YES error:&error];
        }
            
        if (error || !res) { // Show error
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert runModal];
        } else { // Success
            NSString *encryptedString = [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding];
            encryptedString = [encryptedString stringByReplacingOccurrencesOfString:@"ObjectivePGP" withString:@"iPGP"];
            
            // Make that optional
            if (_saveFileCheckBox.state == NSControlStateValueOff)
                [_userInputViewController setString:encryptedString];
            else
                [self saveStringUsingSavePanel:encryptedString];
        }
    }
}

- (void)saveStringUsingSavePanel:(NSString *)encryptedString {
    NSSavePanel *_savePanel = [NSSavePanel savePanel];
    [_savePanel setAllowedFileTypes:@[@"txt"]];
    _savePanel.directoryURL = [NSURL URLWithString:[@"~/" stringByExpandingTildeInPath]];
    [_savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        NSURL *url = [_savePanel URL];
        NSString *filename = url.path;
        NSLog(@"Filename: %@", filename);
        
        NSError *err;
        [encryptedString writeToURL:url atomically:NO encoding:NSUTF8StringEncoding error:&err];
        if (err) {
            NSAlert *alert = [NSAlert alertWithError:err];
            [alert runModal];
        }
    }];
}


- (IBAction)switchSignBox:(NSButton *)sender {
    BOOL flag = sender.state == NSControlStateValueOn;
    _signeeSelection.enabled = flag;
    _passwordTextField.enabled = flag;
    _passwordLbl.textColor = flag ? [NSColor blackColor] : [NSColor grayColor];
    _signeeLbl.textColor = flag ? [NSColor blackColor] : [NSColor grayColor];
}




/*
- (NSArray *)tokenField:(NSTokenField *)tokenField shouldAddObjects:(NSArray *)tokens atIndex:(NSUInteger)index {
    return @[];
}*/


- (nullable NSString *)tokenField:(NSTokenField *)tokenField displayStringForRepresentedObject:(id)representedObject {
    PGPKey *key = representedObject;
    return [key.users.firstObject userID];
    return nil;
}
- (nullable NSString *)tokenField:(NSTokenField *)tokenField editingStringForRepresentedObject:(id)representedObject {
    PGPKey *key = representedObject;
    return [key.users.firstObject userID];
    return nil;
}
- (nullable id)tokenField:(NSTokenField *)tokenField representedObjectForEditingString:(NSString *)editingString {
    for (PGPKey *key in PGPKeys) {
        if (key.type == PGPKeyPublic) {
            if ([[key.users.firstObject userID].lowercaseString containsString:editingString.lowercaseString]) {
                return key;
            }
        }
    }
    return nil;
}


- (nullable NSArray *)tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex indexOfSelectedItem:(NSInteger *)selectedIndex {
    NSMutableArray *res = [NSMutableArray array];
    
    for (PGPKey *key in PGPKeys) {
        if (key.type == PGPKeyPublic) {
            if ([[key.users.firstObject userID].lowercaseString containsString:substring.lowercaseString]) {
                [res addObject:[key.users.firstObject userID]];
            }
        }
    }
    
    return res;
}

@end
