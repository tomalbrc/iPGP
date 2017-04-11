//
//  SecondViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 03.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "DecryptViewController.h"
#import "UIApplicationAdditions.h"

@implementation DecryptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)decryptMessage:(id)sender {
    ObjectivePGP *pgp = [[UIApplication sharedApplication] objectivePGP];
    
    NSData *data = [msgTF.text dataUsingEncoding:NSASCIIStringEncoding];
    
    NSError *error = nil;
    NSData *decryptedData = nil;
    @try {
        decryptedData = [pgp decryptData:data passphrase:passphraseTF.text error:&error];
    } @catch (NSException *exception) {
        msgTF.text = [NSString stringWithFormat:@"ERROR: %@", error.localizedDescription];
    } @finally {
        // Code that gets executed whether or not an exception is thrown
    }
    
    
    if (!error) {
        msgTF.text = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    } else {
        msgTF.text = error.description;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [msgTF resignFirstResponder];
    [passphraseTF resignFirstResponder];
    [secretKeyTF resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
