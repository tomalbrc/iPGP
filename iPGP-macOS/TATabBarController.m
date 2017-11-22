//
//  TATabBarController.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 28.09.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "TATabBarController.h"
#import "KeysTableViewController.h"

@interface TATabBarController () {
    NSTabViewController *tabViewController;
    NSArray<NSButton*> *buttons;
}
@end

@implementation TATabBarController

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedTabVewController"])
        tabViewController = segue.destinationController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    
    buttons = self.buttonBarStackView.arrangedSubviews;
    for (int i = 0; i < buttons.count; i++) {
        NSButton *b = buttons[i];
        b.tag = i;
        [b setState:NSControlStateValueOff];
        [b setTarget:self];
        [b setAction:@selector(pushedButton:)];
    }
    
    [self pushedButton:buttons.firstObject];
}

- (void)pushedButton:(NSButton *)sender {
    NSUInteger oldSelectedButtonIndex = tabViewController.selectedTabViewItemIndex;
    tabViewController.selectedTabViewItemIndex = sender.tag;
    
    buttons[oldSelectedButtonIndex].state = NSControlStateValueOff;
    sender.state = NSControlStateValueOn;
    oldSelectedButtonIndex = sender.tag;
}


@end
