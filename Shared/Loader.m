//
//  Loader.m
//  iPGP
//
//  Created by Tom Albrecht on 28.06.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "Loader.h"
#import "XApplication+Additions.h"
#import <Security/Security.h>

static NSString *kAccountKey = @"key";

@implementation Loader

+ (void)save {
    NSMutableArray *keyDatas = [NSMutableArray array];
    for (PGPKey *key in PGPKeys) {
        NSData *data = [XApplication.sharedApplication.objectivePGP exportKey:key armored:NO];
        [keyDatas addObject:data];
    }
    [self save:keyDatas];
}

+ (void)save:(NSArray *)keysToSave {
    
    
    OSStatus status = SecItemDelete((CFDictionaryRef)@{(id)kSecClass : (id)kSecClassGenericPassword,
                                                       (id)kSecAttrService : [NSBundle mainBundle].bundleIdentifier,
                                                       (id)kSecAttrAccount : kAccountKey});
    NSLog(@"%s - %d", __PRETTY_FUNCTION__, (int)status);
    status = SecItemAdd((__bridge CFDictionaryRef)@{
                                           (id)kSecClass : (id)kSecClassGenericPassword,
                                           (id)kSecAttrService : [NSBundle mainBundle].bundleIdentifier,
                                           (id)kSecAttrAccount : kAccountKey,
                                           (id)kSecValueData : ([NSKeyedArchiver archivedDataWithRootObject:keysToSave])}, nil);
    NSLog(@"%s, %d", __PRETTY_FUNCTION__, (int)status);
}

+ (NSArray *)keys {
    CFTypeRef dataTypeRef = NULL;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)@{(id)kSecClass : (id)kSecClassGenericPassword,
                                                                      (id)kSecAttrService : [NSBundle mainBundle].bundleIdentifier,
                                                                      (id)kSecReturnData : (id)kCFBooleanTrue,
                                                                      (id)kSecAttrAccount : kAccountKey,
                                                                      (id)kSecMatchLimit : (id)kSecMatchLimitOne
                                                                      }, &dataTypeRef);
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)dataTypeRef];
    NSLog(@"OSStatus: %d", (int)status);
    
    return array ? array : [NSArray array];
}

/**
 * Loads key to shared applications openPGP object
 **/
+ (void)loadKeys {
    NSArray *array = self.keys;
    
    for (NSData *asciiKeyData in array) {
        [[[XApplication sharedApplication] objectivePGP] importKeys:[ObjectivePGP readKeysFromData:asciiKeyData]];
    }
    
    // For debugging only
    NSArray *keys = [[[XApplication sharedApplication] objectivePGP] keys];
    for(PGPKey *k in keys) {
        NSLog(@"Short key ID: [%@] - User [%@]", [k.publicKey.keyID shortIdentifier], [(PGPUser *)k.publicKey.users.firstObject userID]);
    }
}

@end
