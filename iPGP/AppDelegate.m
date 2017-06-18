//
//  AppDelegate.m
//  iPGP
//
//  Created by Tom Albrecht on 03.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "UIApplicationAdditions.h"
#import "ObjectivePGP/ObjectivePGP.h"

@implementation AppDelegate

- (NSArray *)loadKeysFromDefaults {
    for (NSString *asciiKey in [[NSUserDefaults standardUserDefaults] arrayForKey:@"keys"]) {
        [[[UIApplication sharedApplication] objectivePGP] importKeysFromData:[asciiKey dataUsingEncoding:NSASCIIStringEncoding] allowDuplicates:NO];
        NSLog(@"Key: %ld", asciiKey.length);
    }
    
    NSArray *keys = [[[UIApplication sharedApplication] objectivePGP] keys];
    
    NSLog(@"Keys: %@", keys);
    for(PGPKey *k in keys) {
        NSLog(@"%@", [k.keyID shortKey]);
    }
    
    return keys;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // This portion is for debugging
    double internalVersion = 1.0;
    if (![[NSUserDefaults standardUserDefaults] arrayForKey:@"keys"] || [[NSUserDefaults standardUserDefaults] doubleForKey:@"version"] < internalVersion) {
        [[NSUserDefaults standardUserDefaults] setDouble:internalVersion forKey:@"version"];
        [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"keys"];
    }
    // end
    
    
    UIColor *colorBars = [UIColor colorWithWhite:0.96f alpha:1.f];
    UIColor *colorButtons = [UIColor colorWithRed:0x62/255.f green:0x00/255.f blue:0xea
                      /255.f alpha:1.f];
    
    //[[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class], [UIToolbar class]]] setTintColor:[UIColor whiteColor]];

    [self loadKeysFromDefaults];
    
    [[UITabBar appearance] setTintColor:colorButtons];
    [[UINavigationBar appearance] setTintColor:colorButtons];
    
    [[UITabBar appearance] setBarTintColor:colorBars];
    [[UINavigationBar appearance] setBarTintColor:colorBars];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.blackColor}];
    [[UIBarButtonItem appearance] setTintColor:colorButtons];
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithWhite:0.93f alpha:1.f]];
    
    [[UIButton appearance] setTintColor:colorButtons];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
