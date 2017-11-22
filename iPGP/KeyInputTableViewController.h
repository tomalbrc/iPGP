//
//  KeyInputTableViewController.h
//  iPGP
//
//  Created by Tom Albrecht on 08.04.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectivePGP/ObjectivePGP.h"

@class KeyInputTableViewController;
@protocol KeyInputTableViewControllerDelegate <NSObject>
- (void)keyInputTableViewController:(KeyInputTableViewController *)keyInputTableViewController didFinishWithKey:(PGPKey *)key;
- (void)keyInputTableViewControllerDidCancel:(KeyInputTableViewController *)keyInputTableViewController;
@end

@interface KeyInputTableViewController : UITableViewController {
    IBOutlet UITextView *textView;
}

@property (assign, nonatomic) BOOL prefersPublic;
@property (assign, nonatomic) id<KeyInputTableViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)saveKey:(id)sender;

@end
