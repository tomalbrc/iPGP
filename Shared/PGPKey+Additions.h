//
//  PGPKey+Additions.h
//  iPGP
//
//  Created by Tom Albrecht on 19.10.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#import <ObjectivePGP/ObjectivePGP.h>

@interface PGPKey (Additions)
- (long)expirationTime;
@end
