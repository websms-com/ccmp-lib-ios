//
//  CCMPUtils.m
//  CCMP
//
//  Created by Christoph Lückler on 02.12.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPUtils.h"

@implementation CCMPUtils

+ (NSNumber *)addressToMsisdn:(NSString *)address {
    if ([address hasPrefix:@"+"]) {
        long long longAddress = [[address stringByReplacingOccurrencesOfString:@"+" withString:@""] longLongValue];
        return [NSNumber numberWithLongLong:longAddress];
    } else {
        return [NSNumber numberWithLongLong:[address longLongValue]];
    }
}

+ (NSString *)msisdnToAddress:(NSNumber *)msisdn {
    return [NSString stringWithFormat:@"+%@", msisdn];
}

+ (NSDate *)convertFromApiDate:(NSNumber *)apiDate {
    if ([apiDate stringValue].length >= 10) {
        return [NSDate dateWithTimeIntervalSince1970:[[[apiDate stringValue] substringToIndex:10] intValue]];
    } else {
        return nil;
    }
}

@end
