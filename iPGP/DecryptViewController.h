//
//  SecondViewController.h
//  iPGP
//
//  Created by Tom Albrecht on 03.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ObjectivePGP/ObjectivePGP.h>

@interface DecryptViewController : UIViewController {
    IBOutlet UITextField *passphraseTF;
    IBOutlet UITextView *secretKeyTF;
    IBOutlet UITextView *msgTF;
}

- (IBAction)decryptMessage:(id)sender;

@end

