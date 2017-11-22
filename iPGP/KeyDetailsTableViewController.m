//
//  KeyDetailsTableViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 15.04.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "KeyDetailsTableViewController.h"
#import <ObjectivePGP/ObjectivePGP.h>
#import <ObjectivePGP/PGPPublicKeyPacket.h>
#import "XApplication+Additions.h"

#import "NSString+Additions.h"
#import "PGPPartialKey+Additions.h"
#import "NSDate+PGPAdditions.h"

#define kHasComment ([[self.key users].firstObject userID].PGPComment && [[self.key users].firstObject userID].PGPComment.length)
#define kHasEmail ([[self.key users].firstObject userID].PGPEmail && [[self.key users].firstObject userID].PGPEmail.length)

static NSString *kDefaultDateFormat = @"dd.MM.yyyy HH:mm";

@interface KeyDetailsTableViewController ()

@end

@implementation KeyDetailsTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    PGPUser *usr = self.key.isPublic ? self.key.publicKey.users.firstObject : self.key.secretKey.users.firstObject;
    PGPPartialKey *partialKey = self.key.isPublic ? self.key.publicKey : self.key.secretKey;
    PGPPublicKeyPacket *packet = (PGPPublicKeyPacket *)partialKey.primaryKeyPacket;
    
    NSString *algoString = [NSString stringForKeyType:[packet publicKeyAlgorithm]];

    algoLbl.text = algoString;
    keysizeLbl.text = [NSString stringWithFormat:@"%ld bit", (unsigned long)packet.keySize*8];
    
    if (!self.key.isSecret) {
        keytypeLbl.text = NSLocalizedString(@"Public", @"Private/Public Label");
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showShareOptions:)];
    } else {
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
    
    
    long expirationTime = [self.key.isPublic ? self.key.publicKey : self.key.publicKey expirationTime];
    
    creationLbl.text = [[packet createDate] stringWithFormat:kDefaultDateFormat];
    expiresLbl.text = expirationTime == 0 ? NSLocalizedString(@"Never", @"Never Label") : [[[packet createDate] dateByAddingTimeInterval:expirationTime] stringWithFormat:kDefaultDateFormat];
    expiresLbl.enabled = expirationTime > 0;
    
    shortKeyLbl.text = self.key.keyID.shortIdentifier;
    longKeyLbl.text = self.key.keyID.longIdentifier;
}

- (void)showShareOptions:(id)sender {
    NSData *result = [[[UIApplication sharedApplication] objectivePGP] exportKey:self.key armored:YES];
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:@[[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]]
                                                                      applicationActivities:nil];
    avc.excludedActivityTypes = @[];
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) [[avc popoverPresentationController] setBarButtonItem:sender];
    [self presentViewController:avc animated:YES completion:NULL];
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
