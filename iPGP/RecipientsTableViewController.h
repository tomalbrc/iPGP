//
//  RecipientsTableViewController.h
//  iPGP
//
//  Created by Tom Albrecht on 12.04.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectivePGP/ObjectivePGP.h"
#import "KeyInputTableViewController.h"

@class RecipientsTableViewController;
@protocol RecipientsTableViewControllerDelegate <NSObject>
- (void)recipientTableViewController:(RecipientsTableViewController *)recipientsTableViewController didSelectKey:(PGPKey *)key;
@end

@interface RecipientsTableViewController : UITableViewController <KeyInputTableViewControllerDelegate> {
    NSMutableArray *publicKeys;
}

@property (assign, nonatomic) id<RecipientsTableViewControllerDelegate> delegate;

@end
