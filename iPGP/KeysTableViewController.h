//
//  KeysTableViewController.h
//  iPGP
//
//  Created by Tom Albrecht on 08.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyInputTableViewController.h"


@interface KeysTableViewController : UITableViewController <KeyInputTableViewControllerDelegate> {
    NSMutableArray *keys;
}

@end
