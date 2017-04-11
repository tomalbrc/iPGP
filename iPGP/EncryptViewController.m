//
//  FirstViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 03.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "EncryptViewController.h"
#import "UIApplicationAdditions.h"

#define kPublicKeyBeginLine @"-----BEGIN PGP PUBLIC KEY BLOCK-----"
#define kPublicKeyEndLine @"-----END PGP PUBLIC KEY BLOCK-----"

@implementation EncryptViewController

- (BOOL)isKey:(NSString *)text {
    return ([text containsString:kPublicKeyBeginLine] && [text containsString:kPublicKeyEndLine]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    publicKeyTF.text = [[UIPasteboard generalPasteboard] string];
    
    NSLog(@"-[ObjPGP keys]: %@", [[[UIApplication sharedApplication] objectivePGP] keys]);
}

- (IBAction)encryptMessage:(id)sender {
    if ([self isKey:publicKeyTF.text]) {
        ObjectivePGP *pgp = [[UIApplication sharedApplication] objectivePGP];
        
        NSArray *keys = [pgp keysFromData:[publicKeyTF.text dataUsingEncoding:NSASCIIStringEncoding]];
        if (keys.count == 0) return;
        
        NSData *data = [msgTF.text dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSData *encryptedData = [pgp encryptData:data usingPublicKey:keys.firstObject armored:YES error:&error];
        
        msgTF.text = [[NSString alloc] initWithData:encryptedData encoding:NSASCIIStringEncoding];
        
        // For saving keys
        //[pgp exportKeys:pgp.keys toFile:@"filepath" error:&error];
        
    } else {
        userInfoLbl.text = @"No valid key!";
    }
}

- (IBAction)showUserInfo:(id)sender {
    if ([self isKey:publicKeyTF.text]) {
        ObjectivePGP *pgp = [[UIApplication sharedApplication] objectivePGP];
        
        NSArray *keys = [pgp keysFromData:[publicKeyTF.text dataUsingEncoding:NSUTF8StringEncoding]];
        if (keys.count == 0) return;
        else if ([keys.firstObject users] == 0) return;
        
        userInfoLbl.text = [[keys.firstObject users].firstObject userID];
    } else {
        userInfoLbl.text = @"No valid key!";
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [msgTF resignFirstResponder];
    [publicKeyTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
