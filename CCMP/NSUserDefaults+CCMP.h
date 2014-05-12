//
//  NSUserDefaults+CCMP.h
//  CCMP
//
//  Created by Christoph Lückler on 11.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CCMPUserDefaults [NSUserDefaults standardUserDefaults]

@interface NSUserDefaults (CCMP)

@property (nonatomic, retain) NSString *pushRegistrationToken;
@property (nonatomic, retain) NSNumber *msisdn;
@property (nonatomic, retain) NSString *deviceToken;
@property (nonatomic, retain) NSString *pin;
@property (nonatomic, retain) NSDictionary *ccmpConfig;

- (NSNumber *)nextDeviceMessageId;

- (void)wipe;

@end
