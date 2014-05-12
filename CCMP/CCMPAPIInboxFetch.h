//
//  CCMPAPIInboxFetch.h
//  CCMP
//
//  Created by Christoph Lückler on 25.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAbstractOperation.h"
#import "CCMPAPIAbstractResponse.h"

@interface CCMPAPIInboxFetchResponse : CCMPAPIAbstractResponse
@property (nonatomic, retain) NSArray *messages;
@end

@interface CCMPAPIMessage : NSObject
@property (nonatomic, retain) NSNumber *messageId;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *sender;
@property (nonatomic, retain) NSDate *createionDate;
@property (nonatomic, assign) BOOL expired;
@property (nonatomic, retain) NSNumber *attachmentId;
@property (nonatomic, assign) BOOL replyable;
@property (nonatomic, assign) BOOL delivered;
@property (nonatomic, retain) NSNumber *accountId;
@property (nonatomic, retain) NSDate *accountRefreshTimestamp;
@property (nonatomic, retain) NSString *additionalPushParameter;
@end

@interface CCMPAPIInboxFetchOperation : CCMPAPIAbstractOperation
@property (nonatomic, retain) CCMPAPIInboxFetchResponse *response;
@end