//
//  KeysTableViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 08.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "KeysTableViewController.h"
#import "KeyDetailsTableViewController.h"
#import "KeyTableViewCell.h"
#import "UIApplicationAdditions.h"
#import "ObjectivePGP/ObjectivePGP.h"

@implementation KeysTableViewController

- (IBAction)showOptions {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"New Key" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *newAction = [UIAlertAction actionWithTitle:@"Generate new Key" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Show new key view controller
    }];
    UIAlertAction *importAction = [UIAlertAction actionWithTitle:@"Import ASCII armored Key" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"KeyInputTableViewControllerContainer"];
        KeyInputTableViewController *kitvc = nc.viewControllers[0];
        kitvc.delegate = self;
        [self presentViewController:nc animated:YES completion:NULL];
    }];
    [ac addAction:cancelAction];
    [ac addAction:newAction];
    [ac addAction:importAction];
    [self presentViewController:ac animated:YES completion:NULL];
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    keys = [[[UIApplication sharedApplication] objectivePGP] keys].mutableCopy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KeyInputTableViewController Delegate

- (void)keyInputTableViewController:(KeyInputTableViewController *)keyInputTableViewController didFinishWithKey:(PGPKey *)key {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    NSData *newKeyData = [[[UIApplication sharedApplication] objectivePGP] exportKey:key armored:YES];
    NSMutableArray *keyArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"keys"].mutableCopy;
    [keyArray addObject:[[NSString alloc] initWithData:newKeyData encoding:NSASCIIStringEncoding]];
    [[NSUserDefaults standardUserDefaults] setObject:keyArray forKey:@"keys"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [keys addObject:key];
    [[[UIApplication sharedApplication] objectivePGP] importKeysFromData:newKeyData allowDuplicates:NO];
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:keys.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)keyInputTableViewControllerDidCancel:(KeyInputTableViewController *)keyInputTableViewController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KeyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PGPKey *key = keys[indexPath.row];
    cell.usernameLabel.text = [[[key users] firstObject] userID];
    cell.descriptionLabel.text = [key type] == 0 ? @"Unknown key type" : key.type == 1 ? @"Secret Key" : @"Public Key";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KeyDetailsTableViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"KeyDetailsTableViewController"];
    c.key = keys[indexPath.row];
    [self.navigationController pushViewController:c animated:YES];
}

@end
