//
//  EncryptTableViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 11.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "EncryptTableViewController.h"
#import "XApplication+Additions.h"

#define kPublicKeyBeginLine @"-----BEGIN PGP PUBLIC KEY BLOCK-----"
#define kPublicKeyEndLine @"-----END PGP PUBLIC KEY BLOCK-----"

@implementation EncryptTableViewController

- (IBAction)copyText:(id)sender {
    [[UIPasteboard generalPasteboard] setString:msgTF.text];
}
- (IBAction)pasteText:(id)sender {
    msgTF.text = [[UIPasteboard generalPasteboard] string];
}
- (IBAction)clearText:(id)sender {
    msgTF.text = nil;
}

- (BOOL)isKey:(NSString *)text {
    return ([text containsString:kPublicKeyBeginLine] && [text containsString:kPublicKeyEndLine]);
}

- (void)encryptMessage {
    if (publicKey && [publicKey type] == PGPKeyPublic) {
        NSData *data = [msgTF.text dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSData *encryptedData = nil;
        @try {
            encryptedData = [[[UIApplication sharedApplication] objectivePGP] encryptData:data usingPublicKey:publicKey armored:YES error:&error];
        } @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                msgTF.text = [NSString stringWithFormat:@"%@", exception.reason];
            });
        } @finally {
            if (!error) msgTF.text = [[NSString alloc] initWithData:encryptedData encoding:NSASCIIStringEncoding];
            else msgTF.text = error.localizedDescription;
        }
        
    } else {
        // Dialogue to select recipient
        
    }
}

- (void)selectRecipient {
    // Show dialogue to select recipient
    UINavigationController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"RecipientsTableViewController"];
    [(RecipientsTableViewController *)[c.viewControllers firstObject] setDelegate:self];
    [self presentViewController:c animated:YES completion:NULL];
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    publicKey = nil;
    
    UIToolbar *toolbar = [UIToolbar new];
    toolbar.items = @[
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:msgTF action:@selector(resignFirstResponder)],
                      ];
    [toolbar sizeToFit];
    msgTF.inputAccessoryView = toolbar;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"MAH %@", publicKey);
    
    //publicKeyTF.text = [[UIPasteboard generalPasteboard] string];
    
    NSLog(@"-[ObjPGP keys]: %@", [[[UIApplication sharedApplication] objectivePGP] keys]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    UINavigationController *c = [segue destinationViewController];
    [(RecipientsTableViewController *)[c.viewControllers firstObject] setDelegate:self];
}

#pragma mark - RecipientsTableViewController delegate
@class PGPSubKey;
- (void)recipientTableViewController:(RecipientsTableViewController *)recipientsTableViewController didSelectKey:(PGPKey *)key {
    publicKey = key;
    recipientLbl.text = [key.users.firstObject userID];
}


#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // Select reci.
        [self selectRecipient];
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        // Encrypt
        [self encryptMessage];
    }
    
    [msgTF resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
