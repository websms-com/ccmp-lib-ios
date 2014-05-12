//
//  CCMPMessageMO.h
//  CCMP
//
//  Created by Christoph Lückler on 26.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "CCMPAccountMO.h"
#import "CCMPAttachmentMO.h"

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

@interface CCMPMessageMO : NSManagedObject

@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSNumber *incoming;
@property (nonatomic, retain) NSNumber *messageId;
@property (nonatomic, retain) NSNumber *deviceMessageId;
@property (nonatomic, retain) NSNumber *read;
@property (nonatomic, retain) NSString *recipient;
@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, retain) NSNumber *sendChannel;
@property (nonatomic, retain) NSString *reference;
@property (nonatomic, retain) NSString *additionalPushParameter;
@property (nonatomic, retain) NSNumber *expired;
@property (nonatomic, retain) NSNumber *replyable;
@property (nonatomic, retain) NSNumber *delivered;

@property (nonatomic, retain) CCMPAttachmentMO *attachment;
@property (nonatomic, retain) CCMPAccountMO *account;
@property (nonatomic, retain) CCMPMessageMO *inReplyTo;
@property (nonatomic, retain) CCMPMessageMO *answer;

@end
