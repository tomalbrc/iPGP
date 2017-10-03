//
//  ViewController.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 24.09.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "ViewController.h"

static const NSString* TypeCell = @"TypeCell";
static const NSString* OwnerCell = @"OwnerCell";
static const NSString* TextCell = @"TextCell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}




- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 1;
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSUInteger columnIndex = [[tableView tableColumns] indexOfObject:tableColumn];
    NSUserInterfaceItemIdentifier identifier = (NSUserInterfaceItemIdentifier)(columnIndex == 0 ? TypeCell : columnIndex == 1 ? OwnerCell : TextCell);
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    
    if (columnIndex == 0) {
        for (NSView *sub in cellView.subviews) {
            if ([sub isKindOfClass:[NSImageView class]]) {
                NSImageView *imageView = (NSImageView *)sub;
                imageView.image = [NSImage imageNamed:@"lock_closed"];
            } else if ([sub isKindOfClass:[NSTextField class]]) {
                NSTextField *tf = (NSTextField *)sub;
                tf.stringValue = @"Private";
            }
        }
    } else {
        NSTextField *tf = cellView.subviews.firstObject;
        tf.stringValue = @"Test";
    }
    
    return cellView;
}





@end
