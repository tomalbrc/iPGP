//
//  SignTableViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 19.07.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "SignTableViewController.h"
#import "DocumentManager.h"

@interface SignTableViewController ()

@end

@implementation SignTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [DocumentManager pickDocumentWithCompletionHandler:^(NSArray<NSURL *> *items) {
            NSLog(@"Items: %@", items);
        }];
    }
}

@end
