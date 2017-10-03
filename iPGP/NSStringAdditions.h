//
//  NSStringAdditions.h
//  iPGP
//
//  Created by Tom Albrecht on 21.06.17.
//  Copyright © 2017 RedWarp Studio. All rights reserved.
//

#ifndef NSStringAdditions_h
#define NSStringAdditions_h

@interface NSString (PGPAdditions)

- (NSString *)PGPName;
- (NSString *)PGPEmail;
- (NSString *)PGPComment;

@end

@implementation NSString (PGPAdditions)

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

@end

#endif /* NSStringAdditions_h */
