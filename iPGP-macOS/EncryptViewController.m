//
//  EncryptViewController.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "EncryptViewController.h"

#import "NSString+Additions.h"

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

    [self switchSignBox:_signeeSelection];
}

- (IBAction)encrypt:(id)sender {
    NSArray<PGPKey *> *keys = [_recipientTokenField objectValue];
    if (_userInputViewController && keys.count) {
        NSError *error;
        NSData *res;
        NSData *userData = _userInputViewController.userData;
        
        if (_signCheckBox.state == NSControlStateValueOn) {
            res = [[NSApplication.sharedApplication objectivePGP] encrypt:userData usingKeys:keys signWithKey:PGPKeys[0] passphrase:_passwordTextField.stringValue armored:!_userInputViewController.isFile error:&error];
        } else {
            res = [[NSApplication.sharedApplication objectivePGP] encrypt:userData usingKeys:keys armored:!_userInputViewController.isFile error:&error];
        }
        
        if (error || !res) { // Show error
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert runModal];
        } else { // Success
            // TODO: Make that optional
            if (_saveFileCheckBox.state == NSControlStateValueOff && !_userInputViewController.isFile) {
                NSString *encryptedString = [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding];
                encryptedString = [encryptedString originatedString];
                
                [_userInputViewController.textView setString:encryptedString];
            } else {
                [self saveDataUsingSavePanel:res];
            }
        }
    }
}

- (void)saveDataUsingSavePanel:(NSData *)encryptedData {
    NSSavePanel *_savePanel = [NSSavePanel savePanel];
    
    // TODO: do
    //[_savePanel setRepresentedURL:nil];
    
    _savePanel.directoryURL = [NSURL URLWithString:[@"~/" stringByExpandingTildeInPath]];
    [_savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (result) {
            NSURL *url = [_savePanel URL];
            NSString *filename = url.path;
            NSLog(@"Filename: %@", filename);
            
            if (![encryptedData writeToURL:url atomically:NO]) {
                NSAlert *alert = [[NSAlert alloc] init];
                [alert runModal];
            }
        }
    }];
}


- (IBAction)switchSignBox:(NSButton *)sender {
    BOOL flag = sender.state == NSControlStateValueOn;
    _signeeSelection.enabled = flag;
    _passwordTextField.enabled = flag;
    _passwordLbl.textColor = flag ? [NSColor blackColor] : [NSColor grayColor];
    _signeeLbl.textColor = flag ? [NSColor blackColor] : [NSColor grayColor];
    
    // move to view will appear
    if (!flag) {
        [_signeeSelection removeAllItems];
    } else {
        for (PGPKey *key in PGPKeys) {
            if (key.isSecret) {
                PGPPartialKey *partialKey = key.isSecret ? key.secretKey : key.publicKey;
                [_signeeSelection addItemWithTitle:[partialKey.users.firstObject userID]];
            }
        }
    }
}




/*
- (NSArray *)tokenField:(NSTokenField *)tokenField shouldAddObjects:(NSArray *)tokens atIndex:(NSUInteger)index {
    return @[];
}*/


- (nullable NSString *)tokenField:(NSTokenField *)tokenField displayStringForRepresentedObject:(id)representedObject {
    PGPKey *key = representedObject;
    return [key.publicKey.users.firstObject userID].PGPName;
    return nil;
}
- (nullable NSString *)tokenField:(NSTokenField *)tokenField editingStringForRepresentedObject:(id)representedObject {
    PGPKey *key = representedObject;
    return [key.publicKey.users.firstObject userID];
    return nil;
}
- (nullable id)tokenField:(NSTokenField *)tokenField representedObjectForEditingString:(NSString *)editingString {
    for (PGPKey *key in PGPKeys) {
        if (key.isPublic) {
            if ([[key.publicKey.users.firstObject userID].lowercaseString containsString:editingString.lowercaseString]) {
                return key;
            }
        }
    }
    return nil;
}


- (nullable NSArray *)tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex indexOfSelectedItem:(NSInteger *)selectedIndex {
    NSMutableArray *res = [NSMutableArray array];
    
    for (PGPKey *key in PGPKeys) {
        if (key.isPublic) {
            if ([[key.publicKey.users.firstObject userID].lowercaseString hasPrefix:substring.lowercaseString]) {
                [res addObject:[key.publicKey.users.firstObject userID]];
            }
        }
    }
    
    return res;
}

@end
