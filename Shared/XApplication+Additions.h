//
//  XApplicationAdditions.h
//  iPGP
//
//  Created by Tom Albrecht on 04.04.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#ifndef UIApplicationAdditions_h
#define UIApplicationAdditions_h

#import <ObjectivePGP/ObjectivePGP.h>

#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#define XApplication NSApplication
#else
#import <UIKit/UIKit.h>
#define XApplication UIApplication
#endif

#define kAppDelegate (AppDelegate *)([XApplication sharedApplication].delegate)
#define PGPKeys [[[XApplication sharedApplication] objectivePGP] keys]

@interface XApplication (additions)
- (NSURL *)applicationDocumentsDirectory;
- (ObjectivePGP *)objectivePGP;
@end



#endif /* UIApplicationAdditions_h */
