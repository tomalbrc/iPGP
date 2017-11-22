//
//  PGPPartialKey+Additions.m
//  iPGP
//
//  Created by Tom Albrecht on 19.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "PGPPartialKey+Additions.h"
#import <ObjectivePGP/ObjectivePGP.h>
#import <ObjectivePGP/PGPSignaturePacket.h>

@implementation PGPPartialKey (Additions)
- (long)expirationTime {
    __block long expirationTime = 0;
    PGPUser *usr = [self users].firstObject;
    PGPSignaturePacket *sig = [usr selfCertifications].firstObject;
    [sig.hashedSubpackets enumerateObjectsUsingBlock:^(PGPSignatureSubpacket *sub, NSUInteger idx, BOOL * _Nonnull stop) {
        if (sub.type == PGPSignatureSubpacketTypeKeyExpirationTime) {
            expirationTime = [sub.value intValue];
            *stop = YES;
        }
    }];
    return expirationTime;
}

@end
