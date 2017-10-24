//
//  Types.h
//  iPGP
//
//  Created by Tom Albrecht on 01.07.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#ifndef Types_h
#define Types_h

#if TARGET_OS_OSX
#define XColor NSColor
#else
#define XColor UIColor
#endif

#define kColorButtons [XColor colorWithRed:0x62/255.f green:0x00/255.f blue:0xea/255.f alpha:1.f]


#endif /* Types_h */
