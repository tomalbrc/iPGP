//
//  AppDelegate.m
//  iPGP
//
//  Created by Tom Albrecht on 03.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "UIApplicationAdditions.h"
#import "Loader.h"
#import "Types.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIColor *colorBars = [UIColor whiteColor];
    
    [[UITabBar appearance] setTintColor:kColorButtons];
    [[UINavigationBar appearance] setTintColor:kColorButtons];
    
    [[UITabBar appearance] setBarTintColor:colorBars];
    [[UINavigationBar appearance] setBarTintColor:colorBars];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.blackColor}];
    [[UIBarButtonItem appearance] setTintColor:kColorButtons];
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithWhite:0.93f alpha:1.f]];
    UITabBarController;
    [[UIButton appearance] setTintColor:kColorButtons];
    
    [[UISegmentedControl appearance] setTintColor:kColorButtons];
    
    [Loader loadKeys];
    
    // Create basic directories
    NSString *docPath = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject.path;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[docPath stringByAppendingPathComponent:@"Imported"]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[docPath stringByAppendingPathComponent:@"Imported"] withIntermediateDirectories:YES attributes:nil error:NULL];
        [[NSFileManager defaultManager] createDirectoryAtPath:[docPath stringByAppendingPathComponent:@"Encrypted"] withIntermediateDirectories:YES attributes:nil error:NULL];
        [[NSFileManager defaultManager] createDirectoryAtPath:[docPath stringByAppendingPathComponent:@"Decrypted"] withIntermediateDirectories:YES attributes:nil error:NULL];
        [[NSFileManager defaultManager] createDirectoryAtPath:[docPath stringByAppendingPathComponent:@"Signed"] withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    // TODO
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
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
