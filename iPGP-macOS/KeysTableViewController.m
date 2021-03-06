//
//  ViewController.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 24.09.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "KeysTableViewController.h"
#import "ObjectivePGP/PGPPublicKeyPacket.h"
#import "ObjectivePGP/PGPSignatureSubpacket.h"
#import "Loader.h"
#import "NSImage+Additions.h"
#import "NSColor+Additions.h"

#import "PGPPartialKey+Additions.h"
#import "NSDate+PGPAdditions.h"

#import "AppDelegate.h"

static NSString *kDefaultDateFormat = @"dd.MM.yyyy HH:mm";

static const NSString* TypeCell = @"TypeCell";
static const NSString* OwnerCell = @"OwnerCell";
static const NSString* TextCell = @"TextCell";

@implementation KeysTableViewController

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationController isKindOfClass:[TextKeyImportViewController class]]) {
        TextKeyImportViewController *vc = segue.destinationController;
        vc.delegate = self;
    } else if ([segue.destinationController isKindOfClass:[GenerateKeyViewController class]]) {
        GenerateKeyViewController *vc = segue.destinationController;
        vc.delegate = self;
        [vc setPreferredContentSize:vc.view.bounds.size];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Loader loadKeys];

    [_tableView becomeFirstResponder];
    // Do any additional setup after loading the view.
}

#pragma mark - TextKeyImportViewControllerDelegate & GenerateKeyViewControllerDelegate

- (void)textKeyImportViewController:(TextKeyImportViewController *)textKeyImportViewController didFinishWithKeys:(NSArray<PGPKey *> *)keys {
    [self importKeys:keys];
    [self dismissViewController:textKeyImportViewController];
}

- (void)generateKeyViewController:(GenerateKeyViewController *)generateKeyViewController didFinishWithKeys:(NSArray<PGPKey *> *)keys {
    [self importKeys:keys];
    [self dismissViewController:generateKeyViewController];
}
     
#pragma mark - Key Import Extras

- (void)importKeys:(NSArray<PGPKey *> *)keys {
    [XApplication.sharedApplication.objectivePGP importKeys:keys];
    [Loader save];
    
    [_tableView reloadData];
}

#pragma mark - NSTableViewDelegate & NSTableViewDataSource
// View based

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return PGPKeys.count;
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSUInteger columnIndex = [[tableView tableColumns] indexOfObject:tableColumn];
    NSUserInterfaceItemIdentifier identifier = (NSUserInterfaceItemIdentifier)(columnIndex == 0 ? TypeCell : columnIndex == 1 ? OwnerCell : TextCell);
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    
    PGPKey *key = PGPKeys[row];
    PGPPartialKey *partialKey = key.isPublic ? key.publicKey : key.secretKey;
    PGPPublicKeyPacket *packet = (PGPPublicKeyPacket *)partialKey.primaryKeyPacket;
    
    if (columnIndex == 0) {
        for (NSView *sub in cellView.subviews) {
            NSColor *imageTint = [NSColor purpleUrple];

            if ([sub isKindOfClass:[NSImageView class]]) {
                NSImageView *imageView = (NSImageView *)sub;
                imageView.image = [[NSImage imageNamed:!key.isSecret ? @"globe" : @"lock_closed"] tintedImageWithColor:imageTint];
            } else if ([sub isKindOfClass:[NSTextField class]]) {
                NSTextField *tf = (NSTextField *)sub;
                tf.textColor = imageTint;
                tf.stringValue = key.isSecret && key.isPublic ? @"Secret & Public" : key.isSecret ? @"Secret" : @"Public";
            }
        }
    } else {
        NSTextField *tf = cellView.subviews.firstObject;
        tf.stringValue = @"";
        
        switch (columnIndex) {
            case 1: {
                NSString *username = [partialKey.users.firstObject userID].PGPName;
                tf.stringValue = username;
                break;
            }
            case 2: {
                NSString *algoString = [NSString stringForKeyType:[packet publicKeyAlgorithm]];
                tf.stringValue = algoString;
                break;
            }
            case 3: {
                NSString *lentgh = [NSString stringWithFormat:@"%ld bit", (unsigned long)packet.keySize*8];
                tf.stringValue = lentgh;
                break;
            }
            case 4: {
                tf.stringValue = [[packet createDate] stringWithFormat:kDefaultDateFormat];
                break;
            }
            case 5: {
                long expirationTime = [partialKey expirationTime];
                
                NSDate *date = [[packet createDate] dateByAddingTimeInterval:expirationTime];
                tf.stringValue = expirationTime == 0 ? @"Never" : [date stringWithFormat:kDefaultDateFormat];
                break;
            }
            default:
                break;
        }
    }
    
    return cellView;
}

@end
