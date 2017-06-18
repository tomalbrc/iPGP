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

@interface UIApplication (additions)
- (NSURL *)applicationDocumentsDirectory;
- (ObjectivePGP *)objectivePGP;
@end

@implementation UIApplication (additions)
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
