//
//  TextKeyImportViewController.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "TextKeyImportViewController.h"
#import "XApplication+Additions.h"

@interface TextKeyImportViewController ()

@end

@implementation TextKeyImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _textView.richText = NO;
}

- (NSArray *)keys {
    NSString *keyString = _textView.string;
    NSData *keyStringData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *keys = [ObjectivePGP readKeysFromData:keyStringData];
    return keys;
}

- (IBAction)importKey:(id)sender {
    NSArray *keys = self.keys;
    
    if (self.delegate)
        [self.delegate textKeyImportViewController:self didFinishWithKeys:keys];
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
    NSString *keyString = _textView.string;
    NSData *keyStringData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *keys = [ObjectivePGP readKeysFromData:keyStringData];
    
    _importButton.enabled = (keys && keys.count > 0);
    
    return YES;
}


@end
