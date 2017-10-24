//
//  Loader.m
//  iPGP
//
//  Created by Tom Albrecht on 28.06.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "Loader.h"
#import "XApplication+Additions.h"
#import <Security/Security.h>

@implementation Loader

+ (void)save:(NSArray *)keysToSave {
    OSStatus status = SecItemDelete((CFDictionaryRef)@{(id)kSecClass : (id)kSecClassGenericPassword,
                                                       (id)kSecAttrService : [NSBundle mainBundle].bundleIdentifier,
                                                       (id)kSecAttrAccount : @"keys"});
    NSLog(@"%s - %d", __PRETTY_FUNCTION__, (int)status);
    status = SecItemAdd((__bridge CFDictionaryRef)@{
                                           (id)kSecClass : (id)kSecClassGenericPassword,
                                           (id)kSecAttrService : [NSBundle mainBundle].bundleIdentifier,
                                           (id)kSecAttrAccount : @"keys",
                                           (id)kSecValueData : ([NSKeyedArchiver archivedDataWithRootObject:keysToSave])}, nil);
    NSLog(@"%s, %d", __PRETTY_FUNCTION__, (int)status);
}

+ (NSArray *)keys {
    CFTypeRef dataTypeRef = NULL;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)@{(id)kSecClass : (id)kSecClassGenericPassword,
                                                                      (id)kSecAttrService : [NSBundle mainBundle].bundleIdentifier,
                                                                      (id)kSecReturnData : (id)kCFBooleanTrue,
                                                                      (id)kSecAttrAccount : @"keys",
                                                                      (id)kSecMatchLimit : (id)kSecMatchLimitOne
                                                                      }, &dataTypeRef);
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)dataTypeRef];
    NSLog(@"OSStatus: %d", (int)status);
    
    return array ? array : [NSArray array];
}

/**
 * Loads key to shared applications openPGP object
 **/
+ (NSArray *)loadKeys {
    NSArray *array = self.keys;
    
    for (NSData *asciiKeyData in array) {
        [[[XApplication sharedApplication] objectivePGP] importKeysFromData:asciiKeyData allowDuplicates:NO];
    }
    
    // For debugging only
    NSArray *keys = [[[XApplication sharedApplication] objectivePGP] keys];
    for(PGPKey *k in keys) {
        NSLog(@"Short key ID: [%@] - User [%@]", [k.keyID shortKey], [(PGPUser *)k.users.firstObject userID]);
    }
    
    return [[XApplication sharedApplication] objectivePGP].keys;
}

+ (void)addKeys:(NSArray<NSData *> *)keyDataArray {
    for (NSData *keyData in keyDataArray) {
        NSArray *res = [[[XApplication sharedApplication] objectivePGP] importKeysFromData:keyData allowDuplicates:NO];
        NSMutableArray *keyArray = self.keys.mutableCopy;
        for (PGPKey *key in res) {
            NSData *exportRes = [[[XApplication sharedApplication] objectivePGP] exportKey:key armored:YES];
            [keyArray addObject:exportRes];
        }
        [self save:keyArray];
    }
}

+ (void)removeKeys:(NSArray<NSData *> *)keyDataArray {
    NSMutableArray *keyArray = self.keys.mutableCopy;
    NSLog(@"Keys now..: %ud", (unsigned)keyArray.count);
    for (NSData *keyData in keyDataArray) {
        PGPKey *key = [[[XApplication sharedApplication] objectivePGP] keysFromData:keyData].firstObject;
        
        for (NSData *kData in keyArray) {
            PGPKey *subRes = [[[XApplication sharedApplication] objectivePGP] keysFromData:kData].firstObject;
            if ([subRes.keyID.longKeyString isEqualToString:key.keyID.longKeyString]) {
                [keyArray removeObject:kData];
                NSLog(@"Removing key...");
                break;
            }
        }
    }
    NSLog(@"Keys after: %ud", (unsigned)keyArray.count);
    [self save:keyArray];
}

@end
