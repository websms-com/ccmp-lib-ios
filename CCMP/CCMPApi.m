//
//  CCMPApi.m
//  CCMP
//
//  Created by Christoph Lückler on 06.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPApi.h"
#import "NSData+CCMP.h"

@interface CCMPApi () {
    NSTimer *queueCheckTimer;
}
@end


@implementation CCMPApi
@synthesize queue;

static CCMPApi *sharedInstance;

const float kQueueCheckTimeIntervall = 15.0;
const int kMaxQueueObjects = 10;


#pragma mark
#pragma mark - Initialization & Deallocation

+ (CCMPApi *)sharedAPI {
	return sharedInstance ?: [self new];
}

- (id)init {
	if (sharedInstance) {
	} else if ((self = sharedInstance = [super init])) {
        queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:1];
        
        queueCheckTimer = [NSTimer scheduledTimerWithTimeInterval: kQueueCheckTimeIntervall
                                                           target: self
                                                         selector: @selector(checkQueue)
                                                         userInfo: nil
                                                          repeats: YES];
	}
	return sharedInstance;
}

- (id)initWithNewInstance {
    self = [super init];
    if (self) {
        queue = [CCMPApi sharedAPI].queue;
    }
    return self;
}

- (void)dealloc {
    if (queueCheckTimer) {
        [queueCheckTimer invalidate];
    }
}


#pragma mark
#pragma mark - API-Queue-Check methods

- (void)checkQueue {
    if (queue.operationCount > kMaxQueueObjects) {
        [self cleanQueue];
    }
    
    if (queue.operationCount == 0 && [UIApplication sharedApplication].networkActivityIndicatorVisible == YES) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)cleanQueue {
    [queue cancelAllOperations];
    [queue waitUntilAllOperationsAreFinished];
}


#pragma mark
#pragma mark - Private methods

- (NSString *)apiBaseUrlForOperation:(Class)opClass {
    if ([_delegate respondsToSelector:@selector(ccmpApi:apiBaseURLForOperation:)]) {
        return [_delegate ccmpApi:self apiBaseURLForOperation:opClass];
    } else {
        return nil;
    }
}

- (NSString *)apiKeyForOperation:(Class)opClass {
    if ([_delegate respondsToSelector:@selector(ccmpApi:apiKeyForOperation:)]) {
        return [_delegate ccmpApi:self apiKeyForOperation:opClass];
    } else {
        return nil;
    }
}


#pragma mark
#pragma mark - Device Operations

- (CCMPAPIDeviceGetOperation *)getDevice:(NSString *)deviceToken {
    
    NSString *apiKey = [self apiKeyForOperation:[CCMPAPIDeviceGetOperation class]];
    NSString *apiBaseUrl = [self apiBaseUrlForOperation:[CCMPAPIDeviceGetOperation class]];
    NSString *methodPath = [NSString stringWithFormat:@"device/%@", deviceToken];
    
    CCMPAPIDeviceGetOperation *op = [[CCMPAPIDeviceGetOperation alloc] initWithBaseUrl: apiBaseUrl
                                                                                  path: methodPath
                                                                                method: CCMPOperationMethodGet
                                                                            jsonObject: nil
                                                                                apiKey: apiKey];
    return op;
}

- (CCMPAPIDeviceRegisterOperation *)registerDevice:(NSNumber *)msisdn {
    
    NSString *apiKey = [self apiKeyForOperation:[CCMPAPIDeviceRegisterOperation class]];
    NSString *apiBaseUrl = [self apiBaseUrlForOperation:[CCMPAPIDeviceRegisterOperation class]];
    NSString *methodPath = @"device/registration/register?send_sms=true";
    
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    if (msisdn) [jsonObject setObject:msisdn forKey:@"msisdn"];
    
    CCMPAPIDeviceRegisterOperation *op = [[CCMPAPIDeviceRegisterOperation alloc] initWithBaseUrl: apiBaseUrl
                                                                                            path: methodPath
                                                                                          method: CCMPOperationMethodPost
                                                                                      jsonObject: [jsonObject.allKeys count] > 0 ? jsonObject : nil
                                                                                          apiKey: apiKey];
    return op;
}

- (CCMPAPIDeviceVerificationOperation *)verifyDevice:(NSString *)deviceToken andPin:(NSString *)pin {
    
    NSString *apiKey = [self apiKeyForOperation:[CCMPAPIDeviceVerificationOperation class]];
    NSString *apiBaseUrl = [self apiBaseUrlForOperation:[CCMPAPIDeviceVerificationOperation class]];
    NSString *methodPath = [NSString stringWithFormat:@"device/registration/%@/verify_pin", deviceToken];
    
    CCMPAPIDeviceVerificationOperation *op = [[CCMPAPIDeviceVerificationOperation alloc] initWithBaseUrl: apiBaseUrl
                                                                                                    path: methodPath
                                                                                                  method: CCMPOperationMethodPost
                                                                                             plainObject: pin
                                                                                                  apiKey: apiKey];
    return op;
}

- (CCMPAPIDeviceUpdateOperation *)updateDevice:(NSString *)deviceToken withMSISDN:(NSNumber *)msisdn andPushId:(NSString *)pushId {
    
    NSString *apiKey = [self apiKeyForOperation:[CCMPAPIDeviceUpdateOperation class]];
    NSString *apiBaseUrl = [self apiBaseUrlForOperation:[CCMPAPIDeviceUpdateOperation class]];
    NSString *methodPath = [NSString stringWithFormat:@"device/%@", deviceToken];
    
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    if (msisdn) [jsonObject setObject:msisdn forKey:@"msisdn"];
    
    if (pushId) {
        [jsonObject setObject:pushId forKey:@"pushId"];
        [jsonObject setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    } else {
        [jsonObject setObject:[NSNumber numberWithBool:NO] forKey:@"enabled"];
    }
    
    CCMPAPIDeviceUpdateOperation *op = [[CCMPAPIDeviceUpdateOperation alloc] initWithBaseUrl: apiBaseUrl
                                                                                        path: methodPath
                                                                                      method: CCMPOperationMethodPut
                                                                                  jsonObject: [jsonObject.allKeys count] > 0 ? jsonObject : nil
                                                                                      apiKey: apiKey];
    return op;
}


#pragma mark
#pragma mark - Outbox Operations

- (CCMPAPIInboxFetchOperation *)getMessagesFrom:(NSString *)deviceToken fromMessageId:(NSNumber *)messageId andLimit:(NSNumber *)limit {
    
    NSString *apiKey = [self apiKeyForOperation:[CCMPAPIInboxFetchOperation class]];
    NSString *apiBaseUrl = [self apiBaseUrlForOperation:[CCMPAPIInboxFetchOperation class]];
    NSString *methodPath = [NSString stringWithFormat:@"device/%@/inbox/fetch", deviceToken];
    
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    if (messageId) [jsonObject setObject:messageId forKey:@"from"];
    if (limit) [jsonObject setObject:limit forKey:@"limit"];

    CCMPAPIInboxFetchOperation *op = [[CCMPAPIInboxFetchOperation alloc] initWithBaseUrl: apiBaseUrl
                                                                                    path: methodPath
                                                                                  method: CCMPOperationMethodPost
                                                                              jsonObject:[jsonObject.allKeys count] > 0 ? jsonObject : nil
                                                                                  apiKey: apiKey];
    return op;
}

- (CCMPAPIOutboxOperation *)sendMessage:(NSString *)content andAttachment:(NSNumber *)attachmentId toAddress:(NSString *)address inReplyTo:(NSNumber *)replyMessageId withDeviceToken:(NSString *)deviceToken {
    
    NSString *apiKey = [self apiKeyForOperation:[CCMPAPIOutboxOperation class]];
    NSString *apiBaseUrl = [self apiBaseUrlForOperation:[CCMPAPIOutboxOperation class]];
    NSString *methodPath = [NSString stringWithFormat:@"device/%@/outbox", deviceToken];
    
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    if (content) [jsonObject setObject:content forKey:@"content"];
    if (attachmentId) [jsonObject setObject:attachmentId forKey:@"attachmentId"];
    if (address) [jsonObject setObject:address forKey:@"recipient"];
    if (replyMessageId) [jsonObject setObject:replyMessageId forKey:@"inReplyTo"];
    
    CCMPAPIOutboxOperation *op = [[CCMPAPIOutboxOperation alloc] initWithBaseUrl: apiBaseUrl
                                                                            path: methodPath
                                                                          method: CCMPOperationMethodPost
                                                                      jsonObject: [jsonObject.allKeys count] > 0 ? jsonObject : nil
                                                                          apiKey: apiKey];
    return op;
}


#pragma mark
#pragma mark - Configuration

- (CCMPAPIConfigurationOperation *)getConfiguration {
    
    NSString *apiKey = [self apiKeyForOperation:[CCMPAPIConfigurationOperation class]];
    NSString *apiBaseUrl = [self apiBaseUrlForOperation:[CCMPAPIConfigurationOperation class]];
    NSString *methodPath = @"device/client/configuration/all";
    
    CCMPAPIConfigurationOperation *op = [[CCMPAPIConfigurationOperation alloc] initWithBaseUrl: apiBaseUrl
                                                                                          path: methodPath
                                                                                        method: CCMPOperationMethodGet
                                                                                    jsonObject: nil
                                                                                        apiKey: apiKey];
    return op;
}


#pragma mark
#pragma mark - Attachments

- (CCMPAPIAttachmentGetOperation *)getUrlForAttachmentKey:(NSNumber *)key withDeviceToken:(NSString *)deviceToken {
    
    NSString *apiKey = [self apiKeyForOperation:[CCMPAPIOutboxOperation class]];
    NSString *apiBaseUrl = [self apiBaseUrlForOperation:[CCMPAPIOutboxOperation class]];
    NSString *methodPath = [NSString stringWithFormat:@"device/%@/attachment/%@?absolute_uri=true", deviceToken, key];
    
    CCMPAPIAttachmentGetOperation *op = [[CCMPAPIAttachmentGetOperation alloc] initWithBaseUrl: apiBaseUrl
                                                                                          path: methodPath
                                                                                        method: CCMPOperationMethodGet
                                                                                    jsonObject: nil
                                                                                        apiKey: apiKey];
    
    [op.request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return op;
}

- (CCMPAPIAttachmentUploadOperation *)uploadAttachment:(NSData *)data mimeType:(NSString *)type withDeviceToken:(NSString *)deviceToken {
    
    NSString *apiKey = [self apiKeyForOperation:[CCMPAPIOutboxOperation class]];
    NSString *apiBaseUrl = [self apiBaseUrlForOperation:[CCMPAPIOutboxOperation class]];
    NSString *methodPath = [NSString stringWithFormat:@"device/%@/attachment", deviceToken];
    
    NSMutableDictionary *jsonObject = [[NSMutableDictionary alloc] init];
    if (data) [jsonObject setObject:[data customBase64EncodedString] forKey:@"data"];
    if (type) [jsonObject setObject:type forKey:@"mimeType"];
    
    CCMPAPIAttachmentUploadOperation *op = [[CCMPAPIAttachmentUploadOperation alloc] initWithBaseUrl: apiBaseUrl
                                                                                                path: methodPath
                                                                                              method: CCMPOperationMethodPost
                                                                                          jsonObject: [jsonObject.allKeys count] > 0 ? jsonObject : nil
                                                                                              apiKey: apiKey];
    
    return op;
}


#pragma mark
#pragma mark - Account

- (CCMPAPIAccountGetOperation *)accountForId:(NSNumber *)accountId {
    
    NSString *apiKey = [self apiKeyForOperation:[CCMPAPIOutboxOperation class]];
    NSString *apiBaseUrl = [self apiBaseUrlForOperation:[CCMPAPIOutboxOperation class]];
    NSString *methodPath = [NSString stringWithFormat:@"device/account/%@/configuration/all", accountId];
    
    
    CCMPAPIAccountGetOperation *op = [[CCMPAPIAccountGetOperation alloc] initWithBaseUrl: apiBaseUrl
                                                                                    path: methodPath
                                                                                  method: CCMPOperationMethodGet
                                                                              jsonObject: nil
                                                                                  apiKey: apiKey];
    return op;

}


#pragma mark
#pragma mark - Configuration Key

- (CCMPAPIConfigurationKeyOperation *)setConfigurationKey:(NSString *)key withValue:(NSString *)value andDeviceToken:(NSString *)deviceToken {
    
    NSString *apiKey = [self apiKeyForOperation:[CCMPAPIOutboxOperation class]];
    NSString *apiBaseUrl = [self apiBaseUrlForOperation:[CCMPAPIOutboxOperation class]];
    NSString *methodPath = [NSString stringWithFormat:@"device/%@/configuration/%@", deviceToken, key];
    
    
    CCMPAPIConfigurationKeyOperation *op = [[CCMPAPIConfigurationKeyOperation alloc] initWithBaseUrl: apiBaseUrl
                                                                                                path: methodPath
                                                                                              method: CCMPOperationMethodPut
                                                                                         plainObject: value
                                                                                              apiKey: apiKey];
    return op;
    
}

@end
