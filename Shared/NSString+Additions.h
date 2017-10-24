//
//  NSStringAdditions.h
//  iPGP
//
//  Created by Tom Albrecht on 21.06.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ObjectivePGP/ObjectivePGP.h>

#ifndef NSStringAdditions_h
#define NSStringAdditions_h

@interface NSString (PGPAdditions)

- (BOOL)isValidKey;
- (BOOL)isValidPublicKey;
- (BOOL)isValidPrivateKey;
- (BOOL)isValidMessage;
- (BOOL)isValidSignature;

- (NSString *)PGPName;
- (NSString *)PGPEmail;
- (NSString *)PGPComment;

+ (NSString *)stringForKeyType:(PGPPublicKeyAlgorithm)algo;
@end

#endif /* NSStringAdditions_h */
