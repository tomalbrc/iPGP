//
//  DecryptTableViewController.h
//  iPGP
//
//  Created by Tom Albrecht on 12.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecryptTableViewController : UITableViewController {
    IBOutlet UITextField *passphraseTF;
    IBOutlet UITextView *msgTF;
}

- (void)decryptMessage;

@end
