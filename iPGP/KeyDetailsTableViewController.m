//
//  KeyDetailsTableViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 15.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "KeyDetailsTableViewController.h"
#import "ObjectivePGP/PGPPublicKeyPacket.h"
#import "ObjectivePGP/PGPSecretKeyPacket.h"

@interface KeyDetailsTableViewController ()

@end

@implementation KeyDetailsTableViewController

- (NSString *)stringForKeyType:(PGPPublicKeyAlgorithm)algo {
    NSString *res = nil;
    switch (algo) {
        case PGPPublicKeyAlgorithmRSA:
            res = @"RSA"; break;
        case PGPPublicKeyAlgorithmRSASignOnly:
            res = @"RSA (Sign only)"; break;
        case PGPPublicKeyAlgorithmRSAEncryptOnly:
            res = @"RSA (Encrypt only)"; break;
        case PGPPublicKeyAlgorithmElgamal:
            res = @"Elgamal"; break;
        case PGPPublicKeyAlgorithmDSA:
            res = @"DSA"; break;
        case PGPPublicKeyAlgorithmElliptic:
            res = @"Elliptic";
        case PGPPublicKeyAlgorithmECDSA:
            res = @"ECDSA";
        default: break;
    }
    return res;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    PGPUser *usr = [self.key users].firstObject;
    if ([[self.key primaryKeyPacket] class] == [PGPPublicKeyPacket class]) {
        PGPPublicKeyPacket *packet = (PGPPublicKeyPacket *)[self.key primaryKeyPacket];
        
        keytypeLbl.text = @"Public";
        algoLbl.text = [self stringForKeyType:packet.publicKeyAlgorithm];
        keysizeLbl.text = [NSString stringWithFormat:@"%ld bits", (unsigned long)packet.keySize*8];
    } else if ([[self.key primaryKeyPacket] class] == [PGPSecretKeyPacket class]) {
        PGPSecretKeyPacket *packet = (PGPSecretKeyPacket *)[self.key primaryKeyPacket];
        
        keytypeLbl.text = @"Private";
        algoLbl.text = [self stringForKeyType:packet.publicKeyAlgorithm];
        keysizeLbl.text = [NSString stringWithFormat:@"%ld bits", (unsigned long)packet.keySize*8];
    }
    
    nameLbl.text = usr.userID;
    commentLbl.text = @"";
    emailLbl.text = @"";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
