//
//  EncryptTableViewController.h
//  iPGP
//
//  Created by Tom Albrecht on 11.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ObjectivePGP/ObjectivePGP.h>
#import "RecipientsTableViewController.h"

@interface EncryptTableViewController : UITableViewController <RecipientsTableViewControllerDelegate> {
    PGPKey *publicKey;
    
    IBOutlet UITextView *msgTF;
    IBOutlet UILabel *recipientLbl;
}

- (void)encryptMessage;
- (void)selectRecipient;

@end
