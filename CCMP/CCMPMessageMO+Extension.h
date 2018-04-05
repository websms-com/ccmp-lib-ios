//
//  CCMPMessageMO+Extension.h
//  CCMP
//
//  Created by Christoph Lückler on 21/07/15.
//  Copyright (c) 2015 Up To Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CCMPMessageStatus) {
    CCMPMessageStatusNone = 0,
    CCMPMessageStatusQueued = 1,
    CCMPMessageStatusSent = 2,
    CCMPMessageStatusFailed = 3
};

typedef NS_ENUM(NSInteger, CCMPMessageSendChannel) {
    CCMPMessageSendChannelNone = 0,
    CCMPMessageSendChannelSMS = 1,
    CCMPMessageSendChannelPush = 2,
    CCMPMessageSendChannelFailed = 3
};

@interface CCMPMessageMO (Extension)

@end
