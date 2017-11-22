//
//  NewKeyTableViewController.h
//  iPGP
//
//  Created by Tom Albrecht on 14.04.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGPKey;
@class GenerateKeyTableViewController;
@protocol GenerateKeyTableViewControllerDelegate <NSObject>
- (void)newKeyTableViewController:(GenerateKeyTableViewController *)viewController didFinishWithKeys:(NSArray<PGPKey*> *)keys;
- (void)newKeyTableViewControllerDidCancel:(GenerateKeyTableViewController *)viewController;
@end

@interface GenerateKeyTableViewController : UITableViewController <UITextFieldDelegate> {
    
}

@property (assign, nonatomic) id <GenerateKeyTableViewControllerDelegate> delegate;

@end
