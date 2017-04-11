//
//  KeysTableViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 08.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "KeysTableViewController.h"
#import "KeyTableViewCell.h"
#import "UIApplicationAdditions.h"

@implementation KeysTableViewController

- (void)loadKeysFromDefaults {
    for (NSString *asciiKey in [[NSUserDefaults standardUserDefaults] arrayForKey:@"keys"]) {
        [[[UIApplication sharedApplication] objectivePGP] importKeysFromData:[asciiKey dataUsingEncoding:NSASCIIStringEncoding] allowDuplicates:NO];
        NSLog(@"Key: %@", asciiKey);
    }
    
    NSUInteger count = keys.count;
    
    keys = [[[UIApplication sharedApplication] objectivePGP] keys];
    
    NSLog(@"Keys: %@", keys);
    for(PGPKey *k in keys) {
        NSLog(@"%@", [k.keyID shortKey]);
    }
    
    if (count != keys.count) {
        [self.tableView reloadData];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self loadKeysFromDefaults];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"Loaded keys: %@", [[NSUserDefaults standardUserDefaults] arrayForKey:@"keys"]);
    
    [self loadKeysFromDefaults];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
