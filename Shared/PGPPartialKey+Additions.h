//
//  PGPPartialKey+Additions.h
//  iPGP
//
//  Created by Tom Albrecht on 19.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import <ObjectivePGP/ObjectivePGP.h>

@interface PGPPartialKey (Additions)
- (long)expirationTime;
@end
