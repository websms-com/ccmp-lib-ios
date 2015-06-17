//
//  CCMPAPIOutboxFetch.m
//  CCMP
//
//  Created by Christoph Lückler on 25.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIInboxFetch.h"

@implementation CCMPAPIInboxFetchResponse
@synthesize messages;
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
        
        // Check for overruling replyable field in additionalPushParameters
        if (message.additionalPushParameter) {
            NSError *err = nil;
            NSData *data = [message.additionalPushParameter dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData: data
                                                                    options: 0
                                                                      error: &err];
            
            if (jsonObj && !err) {
                if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                    NSNumber *replyable = [jsonObj objectForKey:@"replyable"];
                    if (replyable) {
                        message.replyable = [replyable boolValue];
                    }
                }
            }
        }

        [arr addObject:message];
    }
    
    response = [CCMPAPIInboxFetchResponse new];
    response.statusCode = [NSNumber numberWithInteger:statusCode];
    response.messages = [[NSArray alloc] initWithArray:arr];
}

@end