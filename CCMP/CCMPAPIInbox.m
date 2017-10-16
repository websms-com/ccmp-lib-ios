//
//  CCMPAPIOutboxFetch.m
//  CCMP
//
//  Created by Christoph Lückler on 25.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIInbox.h"

@implementation CCMPAPIInboxFetchResponse
@synthesize messages;
@end

@implementation CCMPAPIInboxFetchMessageResponse
@synthesize message;
@end

@implementation CCMPAPIMessage
@synthesize messageId, content, sender, createionDate;
@synthesize expired, attachmentId, replyable, delivered, accountId, accountRefreshTimestamp, additionalPushParameter;

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ > - %@, %@, %@, %@, %d, %@, %d, %d, %@, %@, %@", [self class], messageId, content, sender, createionDate, expired, attachmentId, replyable, delivered, accountId, accountRefreshTimestamp, additionalPushParameter];
}

@end

@implementation CCMPAPIInboxFetchOperation
@synthesize response;

- (void)requestFinishedWithResult:(NSArray *)jsonResult andStatusCode:(NSInteger)statusCode {
    [super requestFinishedWithResult:jsonResult andStatusCode:statusCode];

    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:[jsonResult count]];
    for (NSDictionary *dict in jsonResult) {
        CCMPAPIMessage *message = [[CCMPAPIMessage alloc] init];

        message.messageId = [dict objectForKey:@"id"];
        message.content = [dict objectForKey:@"content"];
        message.sender = [dict objectForKey:@"sender"];
        message.createionDate = [CCMPUtils convertFromApiDate:[dict objectForKey:@"createdOn"]];
        message.expired = [[dict objectForKey:@"expired"] boolValue];
        message.attachmentId = [dict objectForKey:@"attachmentId"];
        message.replyable = [[dict objectForKey:@"replyable"] boolValue];
        message.delivered = [[dict objectForKey:@"delivered"] boolValue];
        message.accountRefreshTimestamp = [CCMPUtils convertFromApiDate:[dict objectForKey:@"accountTimestamp"]];
        message.accountId = [dict objectForKey:@"accountId"];
        message.additionalPushParameter = [dict objectForKey:@"additionalPushParameter"];

        [arr addObject:message];
    }

    response = [CCMPAPIInboxFetchResponse new];
    response.statusCode = [NSNumber numberWithInteger:statusCode];
    response.messages = [[NSArray alloc] initWithArray:arr];
}

@end

@implementation CCMPAPIInboxFetchMessageOperation
@synthesize response;

- (void)requestFinishedWithResult:(NSDictionary *)jsonResult andStatusCode:(NSInteger)statusCode {
    [super requestFinishedWithResult:jsonResult andStatusCode:statusCode];

    response = [[CCMPAPIInboxFetchMessageResponse alloc] initWithDictionary:jsonResult];
    response.statusCode = [NSNumber numberWithInteger:statusCode];

    CCMPAPIMessage *message = [[CCMPAPIMessage alloc] init];
    message.messageId = [jsonResult objectForKey:@"id"];
    message.content = [jsonResult objectForKey:@"content"];
    message.sender = [jsonResult objectForKey:@"sender"];
    message.createionDate = [CCMPUtils convertFromApiDate:[jsonResult objectForKey:@"createdOn"]];
    message.expired = [[jsonResult objectForKey:@"expired"] boolValue];
    message.attachmentId = [jsonResult objectForKey:@"attachmentId"];
    message.replyable = [[jsonResult objectForKey:@"replyable"] boolValue];
    message.delivered = [[jsonResult objectForKey:@"delivered"] boolValue];
    message.accountRefreshTimestamp = [CCMPUtils convertFromApiDate:[jsonResult objectForKey:@"accountTimestamp"]];
    message.accountId = [jsonResult objectForKey:@"accountId"];
    message.additionalPushParameter = [jsonResult objectForKey:@"additionalPushParameter"];

    response.message = message;
}

@end
