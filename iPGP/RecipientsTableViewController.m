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

#import "KeyTableViewCell.h"
#import "NSStringAdditions.h"

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
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ascii" forIndexPath:indexPath];
        cell.textLabel.text = @"Enter ASCII Armored Public Key";
        cell.textLabel.numberOfLines = 0;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        KeyTableViewCell *keyCell = (KeyTableViewCell *)cell;
        
        PGPUser *usr = [publicKeys[indexPath.row] users].firstObject;
        
        keyCell.usernameLabel.text = [usr userID].PGPName;
        keyCell.emailLabel.text = [usr userID].PGPEmail;
        keyCell.descriptionLabel.text = [usr userID].PGPComment;
        keyCell.accessoryType = UITableViewCellAccessoryNone;
        [keyCell setKeytype:PGPKeyPublic];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 65.f;
    else return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
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
