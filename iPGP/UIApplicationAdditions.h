//
//  UIApplicationAdditions.h
//  iPGP
//
//  Created by Tom Albrecht on 04.04.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#ifndef UIApplicationAdditions_h
#define UIApplicationAdditions_h

#import <ObjectivePGP/ObjectivePGP.h>

#if TARGET_OS_OSX
#define XApplication NSApplication
#else
#define XApplication UIApplication
#endif

#define PGPKeys [[[XApplication sharedApplication] objectivePGP] keys]

@interface XApplication (additions)
- (NSURL *)applicationDocumentsDirectory;
- (ObjectivePGP *)objectivePGP;
@end

@implementation XApplication (additions)
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}
- (ObjectivePGP *)objectivePGP {
    static dispatch_once_t once;
    static ObjectivePGP *instance;
    
    dispatch_once(&once, ^{
        instance = [[ObjectivePGP alloc] init];
    });
    
    return instance;
}
@end


#endif /* UIApplicationAdditions_h */
