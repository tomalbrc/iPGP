//
//  FirstViewController.h
//  iPGP
//
//  Created by Tom Albrecht on 03.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ObjectivePGP/ObjectivePGP.h>

@interface EncryptViewController : UIViewController {
    IBOutlet UITextView *publicKeyTF;
    IBOutlet UITextView *msgTF;
    IBOutlet UILabel *userInfoLbl;
}

- (IBAction)encryptMessage:(id)sender;
- (IBAction)showUserInfo:(id)sender;

@end

