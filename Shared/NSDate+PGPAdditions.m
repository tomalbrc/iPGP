//
//  NSDate+PGPAdditions.m
//  iPGP
//
//  Created by Tom Albrecht on 19.10.17.
//  Copyright © 2017 Tom Albrecht. All rights reserved.
//

#import "NSDate+PGPAdditions.h"

@implementation NSDate (PGPAdditions)
- (nullable NSString *)stringWithFormat:(nonnull NSString *)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *dateString = [dateFormat stringFromDate:self];
    return dateString;
}
@end
