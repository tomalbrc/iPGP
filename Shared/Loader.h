//
//  Loader.h
//  iPGP
//
//  Created by Tom Albrecht on 28.06.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PGPKey;

@interface Loader : NSObject
/**
 * Loads keys from iOS/OSX Keychain into XApplication's objetivePGP instance
 */
+ (void)loadKeys;

/**
 * Saves all current keys in keychain
 */
+ (void)save;

@end
