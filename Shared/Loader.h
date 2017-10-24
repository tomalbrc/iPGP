//
//  Loader.h
//  iPGP
//
//  Created by Tom Albrecht on 28.06.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Loader : NSObject
/**
 * Loads keys from iOS/OSX Keychain into memory
 */
+ (NSArray *)loadKeys;

/**
 * Adds a key (ASCII key as NSData*)
 */
+ (void)addKeys:(NSArray<NSData *> *)keyDataArray;

/**
 * Removes specific key by data
 */
+ (void)removeKeys:(NSArray<NSData*> *)keyDataArray;

@end
