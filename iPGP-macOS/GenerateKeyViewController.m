//
//  GenerateKeyViewController.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "GenerateKeyViewController.h"
#import "XApplication+Additions.h"

@interface GenerateKeyViewController ()

@end

@implementation GenerateKeyViewController

- (IBAction)generate:(id)sender {
    BOOL shouldGenerate = YES;
    if (nameTF.stringValue.length <= 0) {
        nameTF.textColor = [NSColor redColor];
        shouldGenerate = NO;
    }
    if (emailTF.stringValue.length <= 0) {
        emailTF.textColor = [NSColor redColor];
        shouldGenerate = NO;
    }
    if (passwordTF.stringValue.length <= 0) {
        passwordTF.textColor = [NSColor redColor];
        shouldGenerate = NO;
    }
    if (passwordConfirmTF.stringValue.length <= 0) {
        nameTF.textColor = [NSColor redColor];
        shouldGenerate = NO;
    }
    
    if (shouldGenerate) [self generateKeys];
}


// TODO: Cross platform Key manager
- (void)generateKeys {
    NSLog(@"Generate keys");
    
    NSInteger algoSelectionIndex = [algoSelection.itemArray indexOfObject:algoSelection.selectedItem];
    NSInteger keyLengthSelectionIndex = [keyLengthSelection.itemArray indexOfObject:keyLengthSelection.selectedItem];
    //NSString *algo = algoSelectionIndex == 0 ? @"rsa" : @"ecc";
    
    int keySize = 384;
    if (algoSelectionIndex == 0)
        keySize = keyLengthSelectionIndex == 0 ? 1024 : keyLengthSelectionIndex == 1 ? 2048 : keyLengthSelectionIndex == 2 ? 4096 : 8192;
    
    
    NSString *name = nameTF.stringValue, *email = emailTF.stringValue, *comment = commentTF.stringValue, *password = passwordTF.stringValue;
    
    PGPKeyGenerator *generator = [[PGPKeyGenerator alloc] init];
    generator.keyAlgorithm = PGPPublicKeyAlgorithmRSA;
    generator.keyBitsLength = keySize;
    PGPKey *key = [generator generateFor:[NSString stringWithFormat:@"%@ <%@>%@", name, email, comment.length > 0 ?  [NSString stringWithFormat:@" (%@)", comment]:@""] passphrase:password.length > 0 ? password : nil];
    NSData *publicKeyData = [key export:PGPPartialKeyPublic error:nil];
    NSData *secretKeyData = [key export:PGPPartialKeySecret error:nil];
    
    if (self.delegate) [self.delegate generateKeyViewController:self didFinishWithKeys:[[ObjectivePGP readKeysFromData:publicKeyData] arrayByAddingObjectsFromArray:[ObjectivePGP readKeysFromData:secretKeyData]]];
}

- (IBAction)expirationDateCheckboxValueChanged:(NSButton *)sender {
    BOOL flag = sender.state == NSControlStateValueOn;
    expirationDateLabel.enabled = flag;
    expirationDatePicker.enabled = flag;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
