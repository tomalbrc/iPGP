//
//  NSStringAdditions.h
//  iPGP
//
//  Created by Tom Albrecht on 21.06.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ObjectivePGP/ObjectivePGP.h>

#ifndef NSStringAdditions_h
#define NSStringAdditions_h

@interface NSString (PGPAdditions)

- (nonnull NSString *)originatedString;

- (BOOL)isValidKey;
- (BOOL)isValidPublicKey;
- (BOOL)isValidPrivateKey;
- (BOOL)isValidMessage;
- (BOOL)isValidSignature;

- (nullable NSString *)PGPName;
- (nullable NSString *)PGPEmail;
- (nullable NSString *)PGPComment;

+ (nonnull NSString *)stringForKeyType:(PGPPublicKeyAlgorithm)algo;
@end

#endif /* NSStringAdditions_h */
