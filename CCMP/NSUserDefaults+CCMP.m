//
//  NSUserDefaults+CCMP.m
//  CCMP
//
//  Created by Christoph Lückler on 11.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "NSUserDefaults+CCMP.h"

@implementation NSUserDefaults (CCMP)


#pragma mark
#pragma mark - Custom Getter & Setter

- (NSString *)pushRegistrationToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"pushRegistrationToken"];
}

- (void)setPushRegistrationToken:(NSString *)pushRegistrationToken {
    LOG(@"setPushRegistrationToken = %@", pushRegistrationToken);
    [[NSUserDefaults standardUserDefaults] setObject:pushRegistrationToken forKey:@"pushRegistrationToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber *)msisdn {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"msisdn"];
}

- (void)setMsisdn:(NSNumber *)msisdn {
    LOG(@"setMsisdn = %@", msisdn);
    [[NSUserDefaults standardUserDefaults] setObject:msisdn forKey:@"msisdn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)deviceToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
}

- (void)setDeviceToken:(NSString *)deviceToken {
    LOG(@"setDeviceToken = %@", deviceToken);
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)pin {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
}

- (void)setPin:(NSString *)pin {
    LOG(@"setPin = %@", pin);
    [[NSUserDefaults standardUserDefaults] setObject:pin forKey:@"pin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)ccmpConfig {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ccmpConfig"];
}

- (void)setCcmpConfig:(NSDictionary *)ccmpConfig {
    LOG(@"setCcmpConfig = %@", ccmpConfig);
    [[NSUserDefaults standardUserDefaults] setObject:ccmpConfig forKey:@"ccmpConfig"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark
#pragma mark - Private methods

- (NSNumber *)nextDeviceMessageId {
    int currentId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceMessageId"] intValue];
    NSNumber *nextId = [NSNumber numberWithInt:(currentId + 1)];
    
    [[NSUserDefaults standardUserDefaults] setObject:nextId forKey:@"deviceMessageId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return nextId;
}


#pragma mark
#pragma mark - Wipe UserDefaults

- (void)wipe {
    [[NSUserDefaults standardUserDefaults] setPersistentDomain: [NSDictionary dictionary]
                                                       forName: [[NSBundle mainBundle] bundleIdentifier]];
}

@end
