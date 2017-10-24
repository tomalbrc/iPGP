//
//  DecryptViewController.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "DecryptViewController.h"
#import "UserInputViewController.h"
#import "XApplication+Additions.h"

@interface DecryptViewController () {
    UserInputViewController *_userInputViewController;
}

@end

@implementation DecryptViewController

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationController isKindOfClass:[UserInputViewController class]])
        _userInputViewController = (UserInputViewController *)segue.destinationController;
}

- (IBAction)decrypt:(id)sender {
    NSData *data = _userInputViewController.userData;
    if (data) {
        
        NSError *error;
        NSData *res = [[NSApplication.sharedApplication objectivePGP] decryptData:data passphrase:_passwordTextField.stringValue error:&error];
        
        if (error) {
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert runModal];
        }
        
        if (_userInputViewController.isFile) {
            NSSavePanel *savePanel = [NSSavePanel savePanel];
            [savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
                
            }];
        } else {
            NSString *string = [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding];
            [_userInputViewController setString:string];
        }
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
