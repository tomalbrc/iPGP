//
//  AppDelegate.m
//  iPGP-macOS
//
//  Created by Tom Albrecht on 24.09.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "AppDelegate.h"
#import "XApplication+Additions.h"

#import "TATabBarController.h"

#import "Loader.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    NSWindow *window = [NSApplication sharedApplication].mainWindow;
    window.movableByWindowBackground = YES;
    window.contentView.wantsLayer = YES;
    //window.backgroundColor = [NSColor colorWithWhite:0.99f alpha:1.f];
    
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}



- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    
}




@end
