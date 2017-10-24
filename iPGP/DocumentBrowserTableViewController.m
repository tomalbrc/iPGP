//
//  DocumentBrowserTableViewController.m
//  iPGP
//
//  Created by Tom Albrecht on 19.07.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "DocumentBrowserTableViewController.h"

#import "Loader.h"
#define kPathForFile(x) [self.currentPath stringByAppendingPathComponent:x]

@interface DocumentBrowserTableViewController () {
    NSMutableArray<NSString *> *files;
}

@property (nonatomic, strong) NSString *currentPath;

@end

@implementation DocumentBrowserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.currentPath == nil) {
        self.currentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    }
    
    
    files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.currentPath error:NULL].mutableCopy;
}

- (void)setCurrentPath:(NSString *)currentPath {
    _currentPath = currentPath;
    self.title = currentPath.lastPathComponent;
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
    return files.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = files[indexPath.row];
    BOOL isdir = NO;
    NSString *filename = files[indexPath.row];
    if ([[NSFileManager defaultManager] fileExistsAtPath:kPathForFile(filename) isDirectory:&isdir]) {
        if (isdir)
            (void)(cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]),
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        else
            (void)(cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody]),
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isdir = NO;
    NSString *filename = files[indexPath.row];
    if ([[NSFileManager defaultManager] fileExistsAtPath:kPathForFile(filename) isDirectory:&isdir]) {
        if (isdir) {
            
            DocumentBrowserTableViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DocumentBrowserTableViewController"];
            dvc.currentPath = [kPathForFile(files[indexPath.row]) stringByAppendingPathComponent:@"/"];
            [self.navigationController pushViewController:dvc animated:YES];
            
        } else {
            UIAlertController *controller = [[UIAlertController alloc] init];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
            [controller addAction:cancelAction];
            
            NSString *ext = [filename pathExtension];
            if ([ext isEqualToString:@"signed"]) {
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Verify Signature" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [Loader addKeys:@[[NSData data]]];
                }];
                [controller addAction:cancelAction];
            }
            if ([ext isEqualToString:@"gpg"]) {
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Import Keychain" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [controller addAction:cancelAction];
            }
            if ([ext isEqualToString:@"key"]) {
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Import Key" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [controller addAction:cancelAction];
            }
            
            
            UIAlertAction *encryptAction = [UIAlertAction actionWithTitle:@"Encrypt" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [controller addAction:encryptAction];
            
            UIAlertAction *decryptAction = [UIAlertAction actionWithTitle:@"Decrypt" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [controller addAction:decryptAction];
            
            [self presentViewController:controller animated:YES completion:^{
                
            }];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error;
        
        [[NSFileManager defaultManager] removeItemAtPath:kPathForFile(files[indexPath.row]) error:&error];
        
        if (error)
            return;
        
        
        [files removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"next"]) {
        DocumentBrowserTableViewController *dvc = segue.destinationViewController;
        dvc.currentPath = self.currentPath;
    }
}


@end
