//
//  KeysTableViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 08.04.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "KeysTableViewController.h"
#import "KeyDetailsTableViewController.h"
#import "KeyTableViewCell.h"
#import "XApplication+Additions.h"
#import "ObjectivePGP/ObjectivePGP.h"

#import "GenerateKeyTableViewController.h"
#import "Loader.h"
#import "NSString+Additions.h"

/**
 * TODO: Key data provider protocol for new and ascii armored keys
 */

@implementation KeysTableViewController

- (IBAction)showOptions:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"New Key" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *newAction = [UIAlertAction actionWithTitle:@"Generate Keypair" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // TODO: Popover for iPad?
        [self performSegueWithIdentifier:@"newKeySegue" sender:self];
    }];
    UIAlertAction *importAction = [UIAlertAction actionWithTitle:@"Import ASCII Key" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"importKeySegue" sender:self];
    }];
    [ac addAction:cancelAction];
    [ac addAction:newAction];
    [ac addAction:importAction];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) [[ac popoverPresentationController] setBarButtonItem:sender];
    
    [self presentViewController:ac animated:YES completion:NULL];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"newKeySegue"] && [segue.destinationViewController isKindOfClass:[GenerateKeyTableViewController class]]) {
        GenerateKeyTableViewController *gVC = (GenerateKeyTableViewController *)segue.destinationViewController;
        gVC.delegate = self;
    } else if ([segue.identifier isEqualToString:@"importKeySegue"] && [segue.destinationViewController isKindOfClass:[KeyInputTableViewController class]]) {
        KeyInputTableViewController *kiVC = (KeyInputTableViewController *)segue.destinationViewController;
        kiVC.delegate = self;
    } else if ([segue.identifier isEqualToString:@"keyDetailSegue"] && [segue.destinationViewController isKindOfClass:[KeyDetailsTableViewController class]]) {
        KeyDetailsTableViewController *c = (KeyDetailsTableViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        c.key = PGPKeys[indexPath.row];
    }
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 65.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KeyInputTableViewController Delegate

- (void)keyInputTableViewController:(KeyInputTableViewController *)keyInputTableViewController didFinishWithKey:(PGPKey *)key {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [UIApplication.sharedApplication.objectivePGP importKeys:@[key]];
    [Loader save];
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:PGPKeys.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)keyInputTableViewControllerDidCancel:(KeyInputTableViewController *)keyInputTableViewController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - NewKeyTableViewController Delegate

- (void)newKeyTableViewController:(GenerateKeyTableViewController *)viewController didFinishWithKeys:(NSArray<PGPKey *> *)pkeys {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [[XApplication sharedApplication].objectivePGP importKeys:pkeys];
    
    [Loader save];
    
    [self.tableView reloadData];
    //[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)newKeyTableViewControllerDidCancel:(GenerateKeyTableViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return PGPKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KeyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PGPKey *key = PGPKeys[indexPath.row];
    PGPUser *user = key.isPublic ? key.publicKey.users.firstObject : key.secretKey.users.firstObject;
    cell.usernameLabel.text = user.userID.PGPName;
    cell.descriptionLabel.text = user.userID.PGPComment;
    cell.emailLabel.text = user.userID.PGPEmail;
    [cell setPublic:[key isPublic]];
    [cell setSecret:[key isSecret]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[[XApplication sharedApplication] objectivePGP] deleteKeys:@[PGPKeys[indexPath.row]]];
        [Loader save];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
