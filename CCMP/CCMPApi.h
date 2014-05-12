//
//  CCMPApi.h
//  CCMP
//
//  Created by Christoph Lückler on 06.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIDeviceGet.h"
#import "CCMPAPIDeviceRegister.h"
#import "CCMPAPIDeviceUpdate.h"
#import "CCMPAPIDeviceVerification.h"
#import "CCMPAPIInboxFetch.h"
#import "CCMPAPIOutbox.h"
#import "CCMPAPIConfiguration.h"
#import "CCMPAPIAttachmentGet.h"
#import "CCMPAPIAttachmentUpload.h"
#import "CCMPAPIAccountGet.h"
#import "CCMPAPIConfigurationKey.h"

@protocol CCMPApiDelegate;
@interface CCMPApi : NSObject {}

@property (nonatomic, assign) id <NSObject, CCMPApiDelegate> delegate;
@property (nonatomic, retain) NSOperationQueue *queue;

+ (CCMPApi *)sharedAPI;

- (id)initWithNewInstance;

- (CCMPAPIDeviceGetOperation *)getDevice:(NSString *)deviceToken;

- (CCMPAPIDeviceRegisterOperation *)registerDevice:(NSNumber *)msisdn;

- (CCMPAPIDeviceVerificationOperation *)verifyDevice:(NSString *)deviceToken andPin:(NSString *)pin;

- (CCMPAPIDeviceUpdateOperation *)updateDevice:(NSString *)deviceToken withMSISDN:(NSNumber *)msisdn andPushId:(NSString *)pushId;

- (CCMPAPIInboxFetchOperation *)getMessagesFrom:(NSString *)deviceToken fromMessageId:(NSNumber *)messageId andLimit:(NSNumber *)limit;

- (CCMPAPIOutboxOperation *)sendMessage:(NSString *)content andAttachment:(NSNumber *)attachmentId toAddress:(NSString *)address inReplyTo:(NSNumber *)replyMessageId withDeviceToken:(NSString *)deviceToken;

- (CCMPAPIConfigurationOperation *)getConfiguration;

- (CCMPAPIAttachmentGetOperation *)getUrlForAttachmentKey:(NSNumber *)key withDeviceToken:(NSString *)deviceToken;

- (CCMPAPIAttachmentUploadOperation *)uploadAttachment:(NSData *)data mimeType:(NSString *)type withDeviceToken:(NSString *)deviceToken;

- (CCMPAPIAccountGetOperation *)accountForId:(NSNumber *)accountId;

- (CCMPAPIConfigurationKeyOperation *)setConfigurationKey:(NSString *)key withValue:(NSString *)value andDeviceToken:(NSString *)deviceToken;

@end

@protocol CCMPApiDelegate
- (NSString *)ccmpApi:(CCMPApi *)api apiKeyForOperation:(Class)opClass;
- (NSString *)ccmpApi:(CCMPApi *)api apiBaseURLForOperation:(Class)opClass;
@end