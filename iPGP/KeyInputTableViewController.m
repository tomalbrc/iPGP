//
//  KeyInputTableViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 08.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "KeyInputTableViewController.h"

#define kPublicKeyBeginLine @"-----BEGIN PGP PUBLIC KEY BLOCK-----"
#define kPublicKeyEndLine   @"-----END PGP PUBLIC KEY BLOCK-----"
#define kSecretKeyBeginLine @"-----BEGIN PGP PRIVATE KEY BLOCK-----"
#define kSecretKeyEndLine   @"-----END PGP PRIVATE KEY BLOCK-----"

@implementation KeyInputTableViewController

- (BOOL)isKey:(NSString *)text {
    return
    ([text containsString:kPublicKeyBeginLine] && [text containsString:kPublicKeyEndLine]) ||
    ([text containsString:kSecretKeyBeginLine] && [text containsString:kSecretKeyEndLine]);
}


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveKey:(id)sender {
    NSLog(@"%@", textView.text);
    
    if ([self isKey:textView.text]) {
        NSMutableArray *keyArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"keys"].mutableCopy;
        [keyArray addObject:textView.text];
        
        [[NSUserDefaults standardUserDefaults] setObject:keyArray forKey:@"keys"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        NSLog(@"FUCK NO KEY");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
