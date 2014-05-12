//
//  CCMPUtils.h
//  CCMP
//
//  Created by Christoph Lückler on 02.12.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "NSUserDefaults+CCMP.h"
#import "NSException+CCMP.h"

@interface CCMPUtils : NSObject

+ (NSNumber *)addressToMsisdn:(NSString *)address;

+ (NSString *)msisdnToAddress:(NSNumber *)msisdn;

+ (NSDate *)convertFromApiDate:(NSNumber *)apiDate;

@end
