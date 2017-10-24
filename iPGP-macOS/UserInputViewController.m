//
//  UserInputViewController.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 07.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "UserInputViewController.h"
#import "TADropView.h"

@interface UserInputViewController ()

@end

@implementation UserInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _textView.string = @"";
    _textView.richText = NO;
    _textView.font = [NSFont systemFontOfSize:15.f];
    
}




- (nullable NSData *)userData {
    if ([_tabView.tabViewItems indexOfObject:_tabView.selectedTabViewItem] == 0)
        return [_textView.string dataUsingEncoding:NSUTF8StringEncoding];
    else
        return [NSData dataWithContentsOfURL:_dropView.fileURL];
    
    return nil;
}
- (BOOL)isFile {
    return [_tabView.tabViewItems indexOfObject:_tabView.selectedTabViewItem] == 1;
}

- (void)setString:(nullable NSString *)string {
    _textView.string = string;
}





- (IBAction)chooseFile:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:nil];
    [openPanel runModal];/* beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        NSLog(@"NSOpenPanel result: %ld", (long)result);
        if (result == NSModalResponseContinue) {
            NSURL *url = openPanel.URL;
            NSLog(@"Selected file URL: %@", url);
            _dropView.image = [NSWorkspace.sharedWorkspace iconForFile:url.path];
        }
    }];*/
}



@end
