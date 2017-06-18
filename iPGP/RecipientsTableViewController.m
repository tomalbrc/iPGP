//
//  RecipientsTableViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 12.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "RecipientsTableViewController.h"
#import "ObjectivePGP/ObjectivePGP.h"
#import "UIApplicationAdditions.h"

@interface RecipientsTableViewController ()

@end

@implementation RecipientsTableViewController

- (IBAction)cancelSelection:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    publicKeys = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[[UIApplication sharedApplication] objectivePGP].keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(PGPKey *)obj type] == PGPKeyPublic) [publicKeys addObject:obj];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : publicKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.section == 1) {
        cell.textLabel.text = [[publicKeys[indexPath.row] users].firstObject userID];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.textLabel.text = @"Enter ASCII Armored Public Key";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self.delegate recipientTableViewController:self didSelectKey:publicKeys[indexPath.row]];
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        KeyInputTableViewController *ki = [self.storyboard instantiateViewControllerWithIdentifier:@"KeyInputTableViewController"];
        ki.delegate = self;
        ki.preferredType = PGPKeyPublic;
        ki.navigationItem.leftBarButtonItem = nil;
        ki.title = @"ASCII armored Key";
        ki.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:ki.navigationItem.rightBarButtonItem.target action:ki.navigationItem.rightBarButtonItem.action];
        ki.navigationItem.rightBarButtonItem = doneItem; // or change style? *shrug*
        [self.navigationController pushViewController:ki animated:YES];
    }
}

#pragma mark - KeyInputTableViewController Delegate

- (void)keyInputTableViewController:(KeyInputTableViewController *)keyInputTableViewController didFinishWithKey:(PGPKey *)key {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)keyInputTableViewControllerDidCancel:(KeyInputTableViewController *)keyInputTableViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
