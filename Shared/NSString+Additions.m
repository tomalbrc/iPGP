//
//  NSString+Additions.m
//  iPGP
//
//  Created by Tom Albrecht on 19.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (PGPAdditions)

- (nonnull NSString *)originatedString {
    NSString *s = [self stringByReplacingOccurrencesOfString:@"Comment: https://www.objectivepgp.com\n" withString:@""];
    return [s stringByReplacingOccurrencesOfString:@"ObjectivePGP" withString:@"iPGP"];
}


- (BOOL)isValidKey {
    return [self isValidPublicKey] || [self isValidPrivateKey];
}
- (BOOL)isValidPublicKey {
    return [self hasPrefix:@"-----BEGIN PGP PUBLIC KEY BLOCK-----"] && [self containsString:@"-----END PGP PUBLIC KEY BLOCK-----"];
}
- (BOOL)isValidPrivateKey {
    return [self hasPrefix:@"-----BEGIN PGP PRIVATE KEY BLOCK-----"] && [self containsString:@"-----END PGP PRIVATE KEY BLOCK-----"];
}
- (BOOL)isValidMessage {
    return [self hasPrefix:@"-----BEGIN PGP MESSAGE-----"] && [self containsString:@"-----END PGP MESSAGE-----"];
}
- (BOOL)isValidSignature {
    return ([self hasPrefix:@"-----BEGIN PGP SIGNATURE-----"] && [self containsString:@"-----END PGP SIGNATURE-----"]) ||[self isValidMessage];
}




- (nullable NSString *)PGPName {
    NSRange range = [self rangeOfString:@" <"];
    NSRange range2 = [self rangeOfString:@" ("];
    if (range.location == NSNotFound && range2.location == NSNotFound) return self;
    
    return [self substringWithRange:NSMakeRange(0, range.location < range2.location ? range.location : range2.location)];
}

- (nullable NSString *)PGPEmail {
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

- (nullable NSString *)PGPComment {
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


+ (nonnull NSString *)stringForKeyType:(PGPPublicKeyAlgorithm)algo {
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
            res = @"Elliptic"; break;
        case PGPPublicKeyAlgorithmECDSA:
            res = @"ECDSA"; break;
        default:
            res = @"Unknown"; break;
    }
    return res;
}
@end
