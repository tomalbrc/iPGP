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

#define WINDOW_COLOR_ACTIVE ([NSColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.f])
#define WINDOW_COLOR_INACTIVE ([NSColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1.f])

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    NSWindow *window = [NSApplication sharedApplication].mainWindow;
    window.movableByWindowBackground = YES;
    window.contentView.wantsLayer = YES;
    window.backgroundColor = WINDOW_COLOR_ACTIVE;
    window.contentView.layer.backgroundColor = WINDOW_COLOR_ACTIVE.CGColor;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}




- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    
}

- (void)applicationWillBecomeActive:(NSNotification *)notification {
    NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
    window.contentView.layer.backgroundColor = WINDOW_COLOR_ACTIVE.CGColor;
    window.backgroundColor = WINDOW_COLOR_ACTIVE;
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    NSWindow *window = [NSApplication sharedApplication].mainWindow;
    window.contentView.layer.backgroundColor = WINDOW_COLOR_INACTIVE.CGColor;
    window.backgroundColor = WINDOW_COLOR_INACTIVE;
}

@end
