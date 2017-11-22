//
//  DecryptViewController.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "DecryptViewController.h"
#import "UserInputViewController.h"
#import "XApplication+Additions.h"
#import "NSString+Additions.h"

#import <ObjectivePGP/PGPPublicKeyEncryptedSessionKeyPacket.h>
#import <ObjectivePGP/PGPPacketFactory.h>

@interface DecryptViewController () {
    UserInputViewController *_userInputViewController;
}

@end

@implementation DecryptViewController

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationController isKindOfClass:[UserInputViewController class]]) {
        _userInputViewController = (UserInputViewController *)segue.destinationController;
        [_userInputViewController.textView setDelegate:self];
    }
}

- (IBAction)decrypt:(id)sender {
    NSData *data = _userInputViewController.userData;
    if (data) {
        
        NSError *error;
        NSData *res = [[NSApplication.sharedApplication objectivePGP] decrypt:data passphrase:_passwordTextField.stringValue error:&error];

        if (error) {
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
                
            }];
            
        }
        
        if (_userInputViewController.isFile) {
            NSSavePanel *savePanel = [NSSavePanel savePanel];
            [savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
                
            }];
        } else {
            NSString *string = [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding];
            [_userInputViewController.textView setString:string];
        }
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _recipientSelection.enabled = NO;
    _userInputViewController.textView.delegate = self;
}
- (void)viewDidAppear {
    [super viewDidAppear];
    _userInputViewController.textView.delegate = self;
}


- (NSArray<PGPKey *> *)recipientKeysForMessage:(NSString *)message {
    NSError *error = nil;
    NSData *messageData = [PGPArmor readArmored:message error:&error];
    
    if (messageData && !error) {
        NSMutableArray *recipientKeyArray = [[NSMutableArray alloc] init];
        NSUInteger offset = 0;
        PGPPacket *packet = [PGPPacketFactory packetWithData:messageData offset:offset nextPacketOffset:&offset];
        
        while ([packet isKindOfClass:[PGPPublicKeyEncryptedSessionKeyPacket class]]) {
            PGPKeyID *keyid = ((PGPPublicKeyEncryptedSessionKeyPacket *)packet).keyID;
            PGPKey *recipientKey = [[XApplication sharedApplication].objectivePGP findKeyWithKeyID:keyid];
            if (recipientKey) {
                [recipientKeyArray addObject: recipientKey];
            }
            packet = [PGPPacketFactory packetWithData:messageData offset:offset nextPacketOffset:&offset];
        }
        return recipientKeyArray;
        
    } else {
        NSLog(@"Error converting message into data");
        return nil;
    }
}


#pragma mark - NSTextViewDelegate

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRanges:(NSArray<NSValue *> *)affectedRanges replacementStrings:(NSArray<NSString *> *)replacementStrings {
    [self textView:textView shouldChangeTextInRange:affectedRanges.firstObject.rangeValue replacementString:replacementStrings.firstObject];
    return YES;
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
    NSLog(@"%s, TextViewString: %@", __PRETTY_FUNCTION__, textView.string);
    NSLog(@"%s, ReplacementString: %@", __PRETTY_FUNCTION__, replacementString);
    NSLog(@"%s, AffectedRange: %@", __PRETTY_FUNCTION__, NSStringFromRange(affectedCharRange));
    NSLog(@"Resulting String: %@", [textView.string stringByAppendingString:replacementString]);
    
    
    [_recipientSelection removeAllItems];
    
    NSString *sanitizedString = affectedCharRange.length > 0 ? [textView.string substringFromIndex:textView.string.length-1] : [textView.string stringByAppendingString:replacementString];
    NSLog(@"Sanitized String: %@", sanitizedString);
    if ([sanitizedString isValidMessage]) {

        NSArray<PGPKey *> *res = [self recipientKeysForMessage:sanitizedString];
        _recipientSelection.enabled = YES;
        
        for (PGPKey *key in res) {
            [_recipientSelection addItemWithTitle:key.isSecret ? [key.secretKey.users.firstObject userID].PGPName : [key.publicKey.users.firstObject userID].PGPName];
        }
        
        if (_recipientSelection.itemTitles.count == 0) {
            [_recipientSelection addItemWithTitle:@"No matching keys"];
            _recipientSelection.enabled = NO;
        }
    }
    return YES;
}

@end
