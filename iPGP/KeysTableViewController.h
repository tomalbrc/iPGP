//
//  KeysTableViewController.h
//  iPGP
//
//  Created by Tom Albrecht on 08.04.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyInputTableViewController.h"
#import "GenerateKeyTableViewController.h"

@interface KeysTableViewController : UITableViewController <KeyInputTableViewControllerDelegate, GenerateKeyTableViewControllerDelegate> {
    
    
}

@end
