//
//  KeyInputTableViewController.h
//  iPGP
//
//  Created by Tom Albrecht on 08.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyInputTableViewController : UITableViewController {
    IBOutlet UITextView *textView;
}

- (IBAction)cancel:(id)sender;
- (IBAction)saveKey:(id)sender;

@end
