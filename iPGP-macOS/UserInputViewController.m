//
//  UserInputViewController.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "UserInputViewController.h"
#import "TADropView.h"

@interface UserInputViewController ()

@end

@implementation UserInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.textView.string = @"";
    self.textView.richText = NO;
    self.textView.font = [NSFont systemFontOfSize:15.f];
}




- (nullable NSData *)userData {
    if (!self.isFile) {
        return [self.textView.string dataUsingEncoding:NSUTF8StringEncoding];
    } else {
        NSError *error;
        NSData *result = [NSData dataWithContentsOfFile:_dropView.fileURL.path options:0 error:&error];
        NSLog(@"File load error: %@", error);
        return result;
    }
}

- (BOOL)isFile {
    return _tabView.tabViewItems.lastObject == _tabView.selectedTabViewItem;
}




- (IBAction)chooseFile:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:nil];
    [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        NSLog(@"NSOpenPanel result: %ld", (long)result);
        if (result) {
            NSURL *url = openPanel.URL;
            NSLog(@"Selected file URL: %@", url);
            _dropView.fileURL = url;
        }
    }];
}

@end
