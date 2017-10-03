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
#import "ObjectivePGP/PGPSignatureSubpacket.h"
#import "UIApplicationAdditions.h"

#import "NSStringAdditions.h"

#define kHasComment ([[self.key users].firstObject userID].PGPComment && [[self.key users].firstObject userID].PGPComment.length)
#define kHasEmail ([[self.key users].firstObject userID].PGPEmail && [[self.key users].firstObject userID].PGPEmail.length)

@interface KeyDetailsTableViewController ()

@end

@implementation KeyDetailsTableViewController

- (NSString *)stringForKeyType:(PGPPublicKeyAlgorithm)algo {
    NSString *res = nil;
    switch (algo) {
        case PGPPublicKeyAlgorithmRSA:
            res = @"RSA"; break;
        case PGPPublicKeyAlgorithmRSASignOnly:
            res = NSLocalizedString(@"RSA (Sign only)", @"Key Algorithm Type"); break;
        case PGPPublicKeyAlgorithmRSAEncryptOnly:
            res = NSLocalizedString(@"RSA (Encrypt only)", @"Key Algorithm Type"); break;
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

- (long)expirationTimeOfKey {
    __block long expirationTime = 0;
    PGPUser *usr = [self.key users].firstObject;
    PGPSignaturePacket *sig = [usr selfCertifications].firstObject;
    [sig.hashedSubpackets enumerateObjectsUsingBlock:^(PGPSignatureSubpacket *sub, NSUInteger idx, BOOL * _Nonnull stop) {
        if (sub.type == PGPSignatureSubpacketTypeKeyExpirationTime) {
            expirationTime = [sub.value intValue];
            *stop = YES;
        }
    }];
    return expirationTime;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    PGPUser *usr = [self.key users].firstObject;
    PGPPublicKeyPacket *packet = (PGPPublicKeyPacket *)[self.key primaryKeyPacket];
    algoLbl.text = [self stringForKeyType:packet.publicKeyAlgorithm];
    keysizeLbl.text = [NSString stringWithFormat:@"%ld bit", (unsigned long)packet.keySize*8];
    
    if ([[self.key primaryKeyPacket] class] == [PGPPublicKeyPacket class]) {
        keytypeLbl.text = NSLocalizedString(@"Public", @"Private/Public Label");
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showShareOptions:)];
    }
    else if ([[self.key primaryKeyPacket] class] == [PGPSecretKeyPacket class]) {
        keytypeLbl.text = NSLocalizedString(@"Private", @"Private/Public Label");
        
        
    }
    
    
    NSString *name = [usr.userID PGPName];
    NSString *email = [usr.userID PGPEmail];
    NSString *comment = [usr.userID PGPComment];

    if (name) nameLbl.text = name;
    else {
        nameLbl.text = NSLocalizedString(@"No name", @"No name placeholder");
        nameLbl.enabled = NO;
    }
    
    if (comment) commentLbl.text = comment;
    else {
        commentLbl.text = NSLocalizedString(@"No comment", @"No comment placeholder");
        commentLbl.enabled = NO;
    }
    
    if (email) emailLbl.text = email;
    else {
        emailLbl.text = NSLocalizedString(@"No Email", @"No Email placeholder");
        emailLbl.enabled = NO;
    }
    
    
    long expirationTime = [self expirationTimeOfKey];
    
    creationLbl.text = [self stringForDate:[(PGPPublicKeyPacket*)[self.key primaryKeyPacket] createDate]];
    expiresLbl.text = expirationTime == 0 ? NSLocalizedString(@"Never", @"Never Label") : [self stringForDate:[[(PGPPublicKeyPacket*)[self.key primaryKeyPacket] createDate] dateByAddingTimeInterval:expirationTime]];
    expiresLbl.enabled = expirationTime > 0;
    
    shortKeyLbl.text = [[self.key keyID] shortKeyString];
    longKeyLbl.text = [[self.key keyID] longKeyString];
}

- (void)showShareOptions:(id)sender {
    NSData *result = [[[UIApplication sharedApplication] objectivePGP] exportKey:self.key armored:YES];
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:@[[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]]
                                                                      applicationActivities:nil];
    avc.excludedActivityTypes = @[];
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) [[avc popoverPresentationController] setBarButtonItem:sender];
    [self presentViewController:avc animated:YES completion:NULL];
}

- (NSString *)stringForDate:(NSDate *)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewAutomaticDimension;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
