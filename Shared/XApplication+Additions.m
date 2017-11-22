//
//  XApplication+Additions.m
//  iPGP
//
//  Created by Tom Albrecht on 19.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XApplication+Additions.h"

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
