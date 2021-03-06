//
//  KeyInputTableViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 08.04.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "KeyInputTableViewController.h"
#import "XApplication+Additions.h"
#import "ObjectivePGP/ObjectivePGP.h"

#define kPublicKeyBeginLine @"-----BEGIN PGP PUBLIC KEY BLOCK-----"
#define kPublicKeyEndLine   @"-----END PGP PUBLIC KEY BLOCK-----"
#define kSecretKeyBeginLine @"-----BEGIN PGP PRIVATE KEY BLOCK-----"
#define kSecretKeyEndLine   @"-----END PGP PRIVATE KEY BLOCK-----"

@implementation KeyInputTableViewController

- (IBAction)copyText:(id)sender {
    [[UIPasteboard generalPasteboard] setString:textView.text];
}
- (IBAction)pasteText:(id)sender {
    textView.text = [[UIPasteboard generalPasteboard] string];
}
- (IBAction)clearText:(id)sender {
    textView.text = nil;
}

- (BOOL)isKey:(NSString *)text {
    return
    ([text containsString:kPublicKeyBeginLine] && [text containsString:kPublicKeyEndLine]) ||
    ([text containsString:kSecretKeyBeginLine] && [text containsString:kSecretKeyEndLine]);
}


- (IBAction)cancel:(id)sender {
    [self.delegate keyInputTableViewControllerDidCancel:self];
}

- (IBAction)saveKey:(id)sender {
    if ([self isKey:textView.text]) {
        NSArray *keys = [ObjectivePGP readKeysFromData:[textView.text dataUsingEncoding:NSASCIIStringEncoding]];
        PGPKey *key = keys.firstObject;
        
        if (_prefersPublic != key.isPublic) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning", @"Warning alert title") message:[NSString stringWithFormat:@"This is not a %@ key", NSLocalizedString([_prefersPublic?@"public":@"secret" capitalizedString], @"Not the right key message")] preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:ac animated:YES completion:NULL];
        }
        
        [self.delegate keyInputTableViewController:self didFinishWithKey:key];
    }
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIToolbar *toolbar = [UIToolbar new];
    toolbar.items = @[
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:textView action:@selector(resignFirstResponder)],
                      ];
    [toolbar sizeToFit];
    
    textView.inputAccessoryView = toolbar;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [textView becomeFirstResponder];
    
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
