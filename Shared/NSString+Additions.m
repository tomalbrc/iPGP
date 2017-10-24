//
//  NSString+Additions.m
//  iPGP
//
//  Created by Tom Albrecht on 19.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (PGPAdditions)

- (BOOL)isValidKey {
    return [self isValidPublicKey] || [self isValidPrivateKey];
}
- (BOOL)isValidPublicKey {
    return YES;
}
- (BOOL)isValidPrivateKey {
    return NO;
}
- (BOOL)isValidMessage {
    return NO;
}
- (BOOL)isValidSignature {
    return NO;
}




- (NSString *)PGPName {
    NSRange range = [self rangeOfString:@" <"];
    NSRange range2 = [self rangeOfString:@" ("];
    if (range.location == NSNotFound && range2.location == NSNotFound) return self;
    
    return [self substringWithRange:NSMakeRange(0, range.location < range2.location ? range.location : range2.location)];
}

- (NSString *)PGPEmail {
    __block NSString *res = nil;
    NSString *test = self;
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:@"<.*>" options:0 error:NULL];
    [expr enumerateMatchesInString:test options:0 range:NSMakeRange(0, test.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        res = [test substringWithRange:NSMakeRange(result.range.location+1, result.range.length-2)];
        NSLog(@"Found %@", res);
        *stop = YES;
    }];
    return res;
}

- (NSString *)PGPComment {
    __block NSString *res = nil;
    NSString *test = self;
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:@"\\(.*\\)" options:0 error:NULL];
    [expr enumerateMatchesInString:test options:0 range:NSMakeRange(0, test.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        res = [test substringWithRange:NSMakeRange(result.range.location+1, result.range.length-2)];
        NSLog(@"Found %@", res);
        *stop = YES;
    }];
    return res;
}


+ (NSString *)stringForKeyType:(PGPPublicKeyAlgorithm)algo {
    NSString *res = nil;
    switch (algo) {
        case PGPPublicKeyAlgorithmRSA:
            res = @"RSA"; break;
        case PGPPublicKeyAlgorithmRSASignOnly:
            res = NSLocalizedString(@"RSA (Sign only)", @"Key Algorithm Type"); break;
        case PGPPublicKeyAlgorithmRSAEncryptOnly:
            res = NSLocalizedString(@"RSA (Encrypt only)", @"Key Algorithm Type"); break;
        case PGPPublicKeyAlgorithmElgamal:
            res = @"Elgamal"; break;
        case PGPPublicKeyAlgorithmDSA:
            res = @"DSA"; break;
        case PGPPublicKeyAlgorithmElliptic:
            res = @"Elliptic";
        case PGPPublicKeyAlgorithmECDSA:
            res = @"ECDSA";
        default: break;
    }
    return res;
}
@end
