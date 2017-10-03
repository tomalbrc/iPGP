//
//  DecryptTableViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 12.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "DecryptTableViewController.h"
#import "UIApplicationAdditions.h"
#import "Types.h"

@implementation DecryptTableViewController

- (IBAction)copyText:(id)sender {
    [[UIPasteboard generalPasteboard] setString:msgTF.text];
}
- (IBAction)pasteText:(id)sender {
    msgTF.text = [[UIPasteboard generalPasteboard] string];
}
- (IBAction)clearText:(id)sender {
    msgTF.text = nil;
}

- (void)decryptMessage {
    ObjectivePGP *pgp = [[UIApplication sharedApplication] objectivePGP];
    
    NSData *data = [msgTF.text dataUsingEncoding:NSASCIIStringEncoding];
    
    NSError *error = nil;
    NSData *decryptedData = nil;
    @try {
        decryptedData = [pgp decryptData:data passphrase:passphraseTF.text error:&error];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
        // Need to get back to main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            msgTF.text = [NSString stringWithFormat:@"ERROR: %@", exception];
        });
    } @finally {
        if (!error) {
            msgTF.text = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
        } else msgTF.text = error.localizedDescription;
    }
}

- (void)resignTextInputs {
    [msgTF resignFirstResponder];
    [passphraseTF resignFirstResponder];
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIToolbar *toolbar = [UIToolbar new];
    toolbar.items = @[
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignTextInputs)],
                      ];
    [toolbar sizeToFit];
    msgTF.inputAccessoryView = toolbar;
    passphraseTF.inputAccessoryView = toolbar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Controller

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self decryptMessage];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
