//
//  ViewController.h
//  iPGP-macOS
//
//  Created by Tom Albrecht on 24.09.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TextKeyImportViewController.h"
#import "GenerateKeyViewController.h"

// TODO: Rename file
// MARK: -
#import "XApplication+Additions.h" // Cross platform,
#import "NSString+Additions.h"

@interface KeysTableViewController : NSViewController <NSTableViewDelegate, NSTableViewDelegate, TextKeyImportViewControllerDelegate, GenerateKeyViewControllerDelegate> {
    IBOutlet NSTableView *_tableView;
}


@end

