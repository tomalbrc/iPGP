//
//  NewKeyTableViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 14.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

@import WebKit;
@import UserNotifications;

#import "GenerateKeyTableViewController.h"
#import "XApplication+Additions.h"

#import "KeysTableViewController.h"

@interface GenerateKeyTableViewController() {
    WKWebView *webView;
    
    IBOutlet UISegmentedControl *bitSelection;
    IBOutlet UISegmentedControl *algoSelection;
    IBOutlet UITextField *nameTF;
    IBOutlet UITextField *emailTF;
    IBOutlet UITextField *commentTF;
    IBOutlet UITextField *passwordTF;
    
    NSMutableDictionary *_keys;
    
    WKUserContentController *userContentController;
}
@end

@implementation GenerateKeyTableViewController

- (IBAction)changeAlgorithm:(id)sender {
    UISegmentedControl *control = bitSelection;
    
    if ([sender selectedSegmentIndex] == 0) {
        // RSA
        [control setEnabled:YES forSegmentAtIndex:0];
        for (int i = 0; i < control.numberOfSegments; ++i) {
            if (control.numberOfSegments < 3) {
                [control insertSegmentWithTitle:@"" atIndex:control.numberOfSegments-1 animated:NO];
            }
            [control setTitle:i==0?@"1024":i==1?@"2048":@"4096" forSegmentAtIndex:i];
        }
    } else {
        // ECC
        [control setTitle:@"256" forSegmentAtIndex:0];
        [control setTitle:@"384" forSegmentAtIndex:1];
        [control setEnabled:NO forSegmentAtIndex:0];
        [control setSelectedSegmentIndex:1];
        for (int i = 2; i < control.numberOfSegments; ++i) [control removeSegmentAtIndex:i animated:NO];
    }
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/**
 * Generate new key. Returns NO if the key creation failed
 */
- (IBAction)generateKey { // TODO: Cross platform key manager class
    _keys = [NSMutableDictionary dictionary];
    
    NSString *algo = algoSelection.selectedSegmentIndex == 0 ? @"rsa" : @"ecc";
    NSUInteger selectedIndex = bitSelection.selectedSegmentIndex;
    
    int keySize = 384;
    if (algoSelection.selectedSegmentIndex == 0) keySize = selectedIndex == 0 ? 1024 : selectedIndex == 1 ? 2048 : selectedIndex == 2 ? 4096 : 8192;
    
    [self.view endEditing:YES];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Generating Keypair", @"Keypair generation wait title")
                                                                   message:[@"\n\n\n" stringByAppendingString:NSLocalizedString(@"Please Wait...", @"Keypair generation wait message")]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [ai startAnimating];
    [ai setFrame:alert.view.bounds];
    [ai setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    ai.userInteractionEnabled = NO;
    [alert.view addSubview:ai];
    
    [self presentViewController:alert animated:YES completion:^{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            PGPKeyGenerator *generator = [[PGPKeyGenerator alloc] init];
            generator.keyAlgorithm = PGPPublicKeyAlgorithmRSA;
            generator.keyBitsLength = keySize;
            PGPKey *key = [generator generateFor:[NSString stringWithFormat:@"%@ <%@>%@", nameTF.text, emailTF.text, commentTF.text.length > 0 ?  [NSString stringWithFormat:@" (%@)", commentTF.text]:@""] passphrase:passwordTF.text.length > 0 ? passwordTF.text : nil];
            NSData *publicKeyData = [key export:PGPPartialKeyPublic error:nil];
            NSData *secretKeyData = [key export:PGPPartialKeySecret error:nil];
            
            NSArray *keys = [[ObjectivePGP readKeysFromData:publicKeyData] arrayByAddingObjectsFromArray:[ObjectivePGP readKeysFromData:secretKeyData]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [(UIAlertController *)self.presentedViewController dismissViewControllerAnimated:YES completion:^{
                    if (self.delegate)
                        [self.delegate newKeyTableViewController:self didFinishWithKeys:keys];
                }];
                
            });
        });
    }];
}

#pragma mark - WebKit stuff

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"Message: %@ %@", message.name, message.body);
    if (message.body != [NSNull null]) _keys[message.name] = [[[UIApplication sharedApplication] objectivePGP] keysFromData:[message.body dataUsingEncoding:NSUTF8StringEncoding]].firstObject;
    
    if (_keys.allValues.count >= 2 && _keys[@"skey"] && _keys[@"pkey"]) {
        if ([self.presentedViewController isKindOfClass:[UIAlertController class]]) {
            
        }
        
        [webView removeFromSuperview];
        webView = nil;
        
        [self sendNotification];
    }
}

- (void)sendNotification {
    // TODO send notification
    UNMutableNotificationContent *content = UNMutableNotificationContent.new;
    content.title = NSLocalizedString(@"Keypair", @"Keypair Generation Alert");
    content.body = NSLocalizedString(@"Generation of the Keypair finished successfully", @"Keypair generation success message");
    content.sound = [UNNotificationSound defaultSound];
    content.categoryIdentifier = @"alarm";
    
    UNNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:NSBundle.mainBundle.bundleIdentifier content:content trigger:trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:NULL];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [algoSelection setEnabled:NO forSegmentAtIndex:1];
    NSLog(@"Tmp dir: %@ ", NSTemporaryDirectory());
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
