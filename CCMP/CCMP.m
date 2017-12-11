//
//  CCMP.m
//  CCMP
//
//  Created by Christoph Lückler on 06.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMP.h"
#import <MessageUI/MessageUI.h>
#import "CCMPApi.h"

@interface CCMP () <CCMPApiDelegate, MFMessageComposeViewControllerDelegate> {
    CCMPApi *api;
    __block NSString *cachedPushIdForInitialLogin;
}
@end


@implementation CCMP
@synthesize apiKey, apiBaseURL;
@synthesize database;

static CCMP *sharedInstance;


#pragma mark
#pragma mark - Initialization

+ (CCMP *)sharedService {
	return sharedInstance ?: [self new];
}

- (id)init {
	if (sharedInstance) {
        CLogDebug(@"Initialize (reuse) %@ ...", NSStringFromClass([self class]));
	} else if ((self = sharedInstance = [super init])) {
        CLogInfo(@"Initialize %@ ...", NSStringFromClass([self class]));

        database = [[CCMPDatabase alloc] init];
        api = [[CCMPApi alloc] init];
        api.delegate = self;
	}
	return sharedInstance;
}

- (id)initWithNewInstance {
    self = [super init];
    if (self) {
        CLogInfo(@"Initialize new Instance of %@ ...", NSStringFromClass([self class]));

        database = [CCMPDatabase sharedDB];
        api = [[CCMPApi alloc] initWithNewInstance];
        api.delegate = self;
    }
    return self;
}


#pragma mark
#pragma mark - APNS-Notification handling
- (void)didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type {
    CLogDebug(@"didUpdatePushCredentials: - %@", credentials.token);

    NSString *newToken = [[[[credentials.token description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                           stringByReplacingOccurrencesOfString: @">" withString: @""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];

    if (![CCMPUserDefaults.pushRegistrationToken isEqualToString:newToken]) {
        [CCMPUserDefaults setPushRegistrationToken:newToken];

        if ([self isRegistered]) {
            [self updateDevice: CCMPUserDefaults.deviceToken
                    withMsisdn: CCMPUserDefaults.msisdn
                     andPushId: newToken];
        }
    }
}

- (void)didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type {
    CLogDebug(@"didReceiveIncomingPushWithPayload: - %@", payload.dictionaryPayload);

    [self didReceiveIncomingPushWithPayload:payload forType:type completionHandler:^(NSError *err){
        if (!err) {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            if (notification) {
                notification.fireDate = [NSDate date];
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.repeatInterval = 0;
                notification.soundName = [payload.dictionaryPayload valueForKeyPath:@"aps.sound"];
                notification.alertBody = [payload.dictionaryPayload valueForKeyPath:@"aps.alert"];

                CLogDebug(@"Scheduling local notification: - %@", notification);
                [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            }
        } else {
            CLogWarn(@"updateInboxWithCompletion failed with error: - %@", err);
        }
    }];
}

- (void)didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type completionHandler:(void (^)(NSError *err))completionHandler {
    CLogDebug(@"didReceiveIncomingPushWithPayload: - %@", payload.dictionaryPayload);

    if ([self isRegistered]) {
        if ([payload.dictionaryPayload valueForKey:@"message_id"] != nil) {
            NSNumber *message_id = [payload.dictionaryPayload valueForKey:@"message_id"];
            [self updateMessageWithCompletion:message_id completionHandler:completionHandler];
        } else {
            [self updateInboxWithCompletion:completionHandler];
        }
    } else {
        CLogWarn(@"Try to update inbox, but user is not authenticated");
    }
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    CLogDebug(@"didRegisterForRemoteNotificationsWithDeviceToken: - %@", deviceToken);
    
    // Parse pushId
    NSString *pushId = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                                    stringByReplacingOccurrencesOfString: @">" withString: @""]
                                                    stringByReplacingOccurrencesOfString: @" " withString: @""];

    if (![self isRegistered]) {
        cachedPushIdForInitialLogin = pushId;
        CLogWarn(@"Can't update pushId because user is not registered");
        return;
    }

    // Check if newToken is equal to cached pushId
    if (!CCMPUserDefaults.pushRegistrationToken || ![CCMPUserDefaults.pushRegistrationToken isEqualToString:pushId]) {
        CLogInfo(@"Update device because cached pushId is invalid (%@)", CCMPUserDefaults.pushRegistrationToken);
        
        [self updateDevice: CCMPUserDefaults.deviceToken
                withMsisdn: CCMPUserDefaults.msisdn
                 andPushId: pushId];

    } else {
        
        // When pushId is not equal get the device information from server and compare the result with newToken
        CCMPAPIDeviceGetOperation *op = [api getDevice:CCMPUserDefaults.deviceToken];

        __block typeof(op) blockOp = op;
        __weak typeof(self) weakSelf = self;
        [op setCompletionBlock:^{
            if (blockOp.response.statusCode.intValue != HTTPStatusCodeOK) {
                return;
            }

            NSString *pushId = blockOp.response.pushId;
            if (pushId == nil || ![pushId isEqualToString:pushId]) {

                CLogInfo(@"Update device because local and remote pushId are not equal or remote pushId is null");

                [weakSelf updateDevice: CCMPUserDefaults.deviceToken
                            withMsisdn: CCMPUserDefaults.msisdn
                             andPushId: pushId];
            } else {
                CLogDebug(@"Supress pushId update because local and remote pushId are equal");
            }
        }];

        [api.queue addOperation:op];
    }
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    CLogError(@"didFailToRegisterForRemoteNotificationsWithError: - %@", error);

    if ([self isRegistered]) {
        [self updateDevice: CCMPUserDefaults.deviceToken
                withMsisdn: CCMPUserDefaults.msisdn
                 andPushId: nil];
    } else {
        CLogWarn(@"Try to reset pushId, but user is not authenticated");
    }
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    CLogDebug(@"didReceiveRemoteNotification: - %@", userInfo);

    if ([self isRegistered]) {
        [self updateInbox];
    } else {
        CLogWarn(@"Try to update inbox, but user is not authenticated");
    }
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification {
    CLogDebug(@"didReceiveLocalNotification: - %@", notification.userInfo);

    if ([self isRegistered]) {
        [self updateInbox];
    } else {
        CLogWarn(@"Try to update inbox, but user is not authenticated");
    }
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    CLogDebug(@"didReceiveRemoteNotification:fetchCompletionHandler: - %@", userInfo);

    if ([self isRegistered]) {
        [self updateInboxWithCompletion:^(NSError *err){
            if (err) {
                completionHandler(UIBackgroundFetchResultFailed);
            } else {
                completionHandler(UIBackgroundFetchResultNewData);
            }
        }];
    } else {
        CLogWarn(@"Try to update inbox, but user is not authenticated");
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

- (void)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)(void))completionHandler {
    CLogDebug(@"handleActionWithIdentifier:forRemoteNotification:fetchCompletionHandler: - %@ | %@", identifier, userInfo);
}


#pragma mark
#pragma mark - User configuration

- (BOOL)isRegistered {
    if (CCMPUserDefaults.deviceToken && CCMPUserDefaults.pin) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isPushEnabled {
    return [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
}

- (void)logout {
    CLogInfo(@"");

    CCMPAPIDeviceUpdateOperation *op = [api updateDevice: CCMPUserDefaults.deviceToken
                                              withMSISDN: CCMPUserDefaults.msisdn
                                               andPushId: nil];
    
    [op setCompletionBlock:^{
        [CCMPUserDefaults setPushRegistrationToken:nil];
        [CCMPUserDefaults setMsisdn:nil];
        [CCMPUserDefaults setDeviceToken:nil];
        [CCMPUserDefaults setPin:nil];
        [CCMPUserDefaults setCcmpConfig:nil];

        dispatch_async(dispatch_get_main_queue(), ^{
            [database wipeDatabase];
            [database commit];
        });
    }];
    
    [api.queue addOperation:op];
}


#pragma mark
#pragma mark - Registration & Verification

- (void)sendPinRequest:(NSNumber *)msisdn {
    CLogDebug(@"msisdn = %@", msisdn);

    if (msisdn == nil || [msisdn stringValue].length < 4) {
        [NSException throwException:@"A is in the wrong format - %@", msisdn];
    }
    
    CCMPAPIDeviceRegisterOperation *op = [api registerDevice:msisdn];
    __block CCMPAPIDeviceRegisterOperation *bop = op;
    
    [op setCompletionBlock:^{
        if (bop.response.statusCode.intValue != HTTPStatusCodeCreated) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationSentPin
                                                                    object: bop.error];
            });
            return;
        }

        if (bop.response.deviceToken) {
            [CCMPUserDefaults setDeviceToken:bop.response.deviceToken];
        }

        if (msisdn) {
            [CCMPUserDefaults setMsisdn:msisdn];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationSentPin
                                                                object: nil];
        });
    }];

    [api.queue addOperation:op];
}

- (void)verifyMsisdn:(NSNumber *)msisdn withPin:(NSString *)pin {
    CLogDebug(@"msisdn = %@, pin = %@", msisdn, pin);

    if (msisdn == nil || [msisdn stringValue].length < 4) {
        [NSException throwException:@"MSISDN is in the wrong format - %@", msisdn];
    } else if (pin.length < 4) {
        [NSException throwException:@"Pin is too short - %@", pin];
    }

    CCMPAPIDeviceVerificationOperation *op = [api verifyDevice: CCMPUserDefaults.deviceToken
                                                        andPin: pin];
    __block CCMPAPIDeviceVerificationOperation *bop = op;
    
    [op setCompletionBlock:^{
        if (bop.response.statusCode.intValue != HTTPStatusCodeOK) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationVerifiedDevice
                                                                    object: bop.error];
            });
            return;
        }

        [CCMPUserDefaults setPin:pin];

        NSString *pushId = CCMPUserDefaults.pushRegistrationToken;
        if (!pushId) {
            pushId = cachedPushIdForInitialLogin;
        }

        // Update the pushId after the registration process
        [self updateDevice: CCMPUserDefaults.deviceToken
                withMsisdn: CCMPUserDefaults.msisdn
                 andPushId: pushId];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationVerifiedDevice
                                                                object: nil];

        });
    }];

    [api.queue addOperation:op];
}

- (void)updateDevice:(NSString *)device withMsisdn:(NSNumber *)msisdn andPushId:(NSString *)pushId {
    CLogDebug(@"device = %@, msisdn = %@, pushId = %@", device, msisdn, pushId);

    CCMPAPIDeviceUpdateOperation *updateOP = [api updateDevice: device
                                                    withMSISDN: msisdn
                                                     andPushId: pushId];
    __block CCMPAPIDeviceUpdateOperation *updateBOP = updateOP;

    [updateOP setCompletionBlock:^{
        if (updateBOP.response.statusCode.intValue != HTTPStatusCodeOK) {
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (msisdn) {
                [CCMPUserDefaults setMsisdn:msisdn];
            }

            [CCMPUserDefaults setPushRegistrationToken:pushId];

            [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationDeviceUpdated
                                                                object: nil];
        });
    }];
    
    CCMPAPIConfigurationOperation *configOP = [api getConfiguration];
    __block CCMPAPIConfigurationOperation *configBOP = configOP;

    [configOP setCompletionBlock:^{
        if (configBOP.response.statusCode.intValue != HTTPStatusCodeOK) {
            return;
        }

        [CCMPUserDefaults setCcmpConfig:configBOP.response.configuration];
    }];

    [updateOP addDependency:configOP];
    [api.queue addOperations:@[updateOP, configOP] waitUntilFinished:NO];
}


#pragma mark
#pragma mark - Inbox / Outbox

- (void)updateInbox {
    [self updateInboxWithCompletion:nil];
}

- (void)updateInboxWithCompletion:(void (^)(NSError *err))block {
    if (![self isRegistered]) {
        [NSException throwException:@"Device is not registrated"];
    }

    CLogDebug(@"");

    CCMPAPIInboxFetchOperation *op = [api getMessagesFrom: CCMPUserDefaults.deviceToken
                                            fromMessageId: nil
                                                 andLimit: nil];
    __block CCMPAPIInboxFetchOperation *bop = op;

    [op setCompletionBlock:^{
        CLogDebug(@"Completion of updateInboxWithCompletion with statusCode=%d and error=%@", bop.response.statusCode.intValue, bop.error);
        if (bop.response.statusCode.intValue != HTTPStatusCodeOK) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationInboxUpdated
                                                                    object: bop.error];

                if (block) {
                    block(bop.error);
                }
            });
            return;
        }

        for (CCMPAPIMessage *msg in bop.response.messages) {
            [self processMessage:msg];
        }

        [database commit:^(BOOL success, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationInboxUpdated
                                                                    object: nil];

                if (block) {
                    block(nil);
                }
            });
        }];
    }];

    [api.queue addOperation:op];
}

- (void)updateMessageWithCompletion:(NSNumber *)messageId completionHandler:(void (^)(NSError *err))block {
    if (![self isRegistered]) {
        [NSException throwException:@"Device is not registrated"];
    }

    CLogDebug(@"Trying to fetch message with id %@", messageId);

    CCMPAPIInboxGetMessageOperation *op = [api getMessage: CCMPUserDefaults.deviceToken
                                                  messageId: messageId];
    __block CCMPAPIInboxGetMessageOperation *bop = op;

    [op setCompletionBlock:^{
        CLogDebug(@"Completion of updateMessageWithCompletion with statusCode=%d and error=%@", bop.response.statusCode.intValue, bop.error);
        if (bop.response.statusCode.intValue != HTTPStatusCodeOK || bop.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationInboxUpdated
                                                                    object: bop.error];

                if (block) {
                    block(bop.error);
                }
            });
            return;
        }

        [self processMessage:bop.response.message];

        [database commit:^(BOOL success, NSError *error){

            if (success) {
                CCMPAPIInboxFetchMessageOperation *fetchOp = [api fetchMessage:CCMPUserDefaults.deviceToken messageId:messageId];
                [fetchOp main];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationInboxUpdated
                                                                    object: nil];
                if (block) {
                    block(error);
                }
            });
        }];
    }];

    [api.queue addOperation:op];
}
- (void)processMessage:(CCMPAPIMessage *)msg {
    CCMPMessageMO *message = [database addMessageWithMessageId: msg.messageId
                                                       content: msg.content
                                                     recipient: msg.sender
                                                      incoming: YES
                                                          read: NO
                                                        status: CCMPMessageStatusNone
                                                   sendChannel: CCMPMessageSendChannelNone
                                                          date: msg.createionDate];

    message.expired = [NSNumber numberWithBool:msg.expired];
    message.delivered = [NSNumber numberWithBool:msg.delivered];
    message.replyable = [NSNumber numberWithBool:msg.replyable];

    if (msg.additionalPushParameter) {
        message.additionalPushParameter = msg.additionalPushParameter;
    }

    // Check for attachments
    if ([msg.attachmentId intValue] != 0) {
        CCMPAPIAttachmentGetOperation *attachmentOp = [api getUrlForAttachmentKey: msg.attachmentId
                                                                  withDeviceToken: CCMPUserDefaults.deviceToken];

        [attachmentOp main];

        if ([attachmentOp.response.statusCode integerValue] == HTTPStatusCodeOK) {
            message.attachment = [database addAttachmentWithAttachmentId: msg.attachmentId
                                                                fileName: attachmentOp.response.name
                                                                fileSize: attachmentOp.response.size
                                                                mimeType: [CCMPAttachmentMO attachmentTypeForMimeType:attachmentOp.response.mimeType]
                                                                     url: [NSURL URLWithString:attachmentOp.response.uri]];
        }
    }

    // Check for account information
    if ([msg.accountId intValue] > 0) {
        CCMPAccountMO *account = [database getAccountWithId:msg.accountId];

        if (!account || ![account.refreshTimestamp isEqualToDate:msg.accountRefreshTimestamp]) {
            CCMPAPIAccountGetOperation *accountOp = [api accountForId:msg.accountId];
            [accountOp main];

            if ([accountOp.response.statusCode integerValue] == HTTPStatusCodeOK) {
                account = [database addAccountWithId: msg.accountId
                                         displayName: accountOp.response.displayName
                                           avatarURL: [NSURL URLWithString:accountOp.response.displayImageUrl]];

                account.replyable = [NSNumber numberWithBool:accountOp.response.replyable];
                account.refreshTimestamp = msg.accountRefreshTimestamp;
            }
        }

        message.account = account;
        account.lastMessageDate = message.date;
    }
    CLogDebug(@"Finished processing message %@", msg.messageId);
}

- (void)sendMessage:(NSString *)text toRecipient:(NSString *)address inReplyTo:(NSNumber *)messageId {
    CLogDebug(@"message = %@, recipient = %@", text, address);

    if (text.length == 0) {
        [NSException throwException:@"Can't send empty message"];
    } else if (address == nil) {
        [NSException throwException:@"Address is invalid - %@", address];
    }

    // Add message to database
    __block CCMPMessageMO *message = [database addMessageWithMessageId: nil
                                                               content: text
                                                             recipient: address
                                                              incoming: NO
                                                                  read: YES
                                                                status: CCMPMessageStatusQueued
                                                           sendChannel: CCMPMessageSendChannelNone
                                                                  date: [NSDate date]];

    if (messageId) {
        CCMPMessageMO *replyMessage = [database getMessageWithId:messageId];
        message.inReplyTo = replyMessage;
        message.account = replyMessage.account;
    }
    
    [database commit:^(BOOL success, NSError *error) {
        // Check send Channel
        if ([self isRegistered]) {
            [self sendMessage:message];
        } else {
            [self sendFallbackMessage:message];
        }
    }];
}

- (void)sendMessage:(NSString *)text andAttachment:(NSData *)attachment withMimeType:(NSString *)mimeType toRecipient:(NSString *)address inReplyTo:(NSNumber *)messageId {
    CLogDebug(@"message = %@, attachment = %@, recipient = %@", text, attachment.description, address);

    if (attachment.length == 0) {
        [NSException throwException:@"Can't send empty attachment"];
    } else if (address == nil) {
        [NSException throwException:@"Address is invalid - %@", address];
    }

    CCMPAPIAttachmentUploadOperation *op1 = [api uploadAttachment: attachment
                                                         mimeType: mimeType
                                                  withDeviceToken: CCMPUserDefaults.deviceToken];

    __block CCMPAPIAttachmentUploadOperation *bop1 = op1;

    [op1 setCompletionBlock:^{
        if (bop1.response.statusCode.intValue != HTTPStatusCodeCreated) {
            CLogError(@"Upload failed: %@", bop1.error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationAttachmentUploadFailed
                                                                    object: bop1.error];
            });

            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            CCMPAPIAttachmentGetOperation *op2 = [api getUrlForAttachmentKey: bop1.response.attachmentId
                                                             withDeviceToken: CCMPUserDefaults.deviceToken];
            __block CCMPAPIAttachmentGetOperation *bop2 = op2;
            
            [op2 setCompletionBlock:^{
                if (bop2.response.statusCode.intValue != HTTPStatusCodeOK) {
                    CLogError(@"Get attachmentUrl failed: %@", bop2.error);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationAttachmentUploadFailed
                                                                            object: bop2.error];
                    });

                    return;
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sendMessage: [text stringByAppendingString:bop2.response.uri]
                          toRecipient: address
                            inReplyTo: messageId];
                });
            }];

            [api.queue addOperation:op2];
        });
    }];

    [api.queue addOperation:op1];
}

- (void)sendMessage:(CCMPMessageMO *)msg {

    CCMPAPIOutboxOperation *op = [api sendMessage: msg.content
                                    andAttachment: nil
                                        toAddress: msg.recipient
                                        inReplyTo: msg.inReplyTo.messageId
                                  withDeviceToken: CCMPUserDefaults.deviceToken];
    
    __block CCMPAPIOutboxOperation *bop = op;

    [op setCompletionBlock:^{
        if (bop.response.statusCode.intValue != HTTPStatusCodeOK) {
            CLogError(@"Sending Failed: %@", bop.error);
            [self sendFallbackMessage:msg];
            return;
        }

        [database updateMessage: msg
                        content: nil
                           read: [msg.read boolValue]
                         status: CCMPMessageStatusSent
                    sendChannel: CCMPMessageSendChannelPush];

        [database commit:^(BOOL success, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationMessageSent
                                                                    object: msg];
            });
        }];
    }];

    [api.queue addOperation:op];
}

- (void)sendFallbackMessage:(CCMPMessageMO *)msg {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageComposer = [[MFMessageComposeViewController alloc] init];
        [messageComposer setBody:msg.content];
        [messageComposer setRecipients:@[msg.recipient]];
        messageComposer.messageComposeDelegate = self;

        UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
        [rootVC presentViewController:messageComposer animated:YES completion:nil];
    } else {
        [database updateMessage: msg
                        content: nil
                           read: [msg.read boolValue]
                         status: CCMPMessageStatusFailed
                    sendChannel: CCMPMessageSendChannelNone];

        [database commit:^(BOOL success, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationMessageSent
                                                                    object: msg];
            });
        }];
    }
}


#pragma mark
#pragma mark - MFMessageComposeViewController Delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootVC dismissViewControllerAnimated:YES completion:nil];

    __block CCMPMessageMO *message = [[database getAllQueuedMessages] lastObject];

    // Check message result
    if (result == MessageComposeResultFailed) {
        CLogError(@"Failed to send SMS ... MessageComposeResultFailed");

        [database updateMessage: message
                        content: nil
                           read: [message.read boolValue]
                         status: CCMPMessageStatusFailed
                    sendChannel: CCMPMessageSendChannelNone];
    } else if (result == MessageComposeResultCancelled) {
        CLogError(@"Failed to send SMS ... MessageComposeResultCancelled");

        [database deleteMessage: message
                  andReferences: NO];
    } else {
        CLogError(@"SMS sent ... MessageComposeResultSent");

        [database updateMessage: message
                        content: nil
                           read: [message.read boolValue]
                         status: CCMPMessageStatusSent
                    sendChannel: CCMPMessageSendChannelSMS];
    }

    // Commit to database
    [database commit:^(BOOL success, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationMessageSent
                                                                object: message];
        });
    }];
}


#pragma mark
#pragma mark - CCMPApi delegate

- (NSString *)ccmpApi:(CCMPApi *)api apiBaseURLForOperation:(Class)opClass {
    return apiBaseURL;
}

- (NSString *)ccmpApi:(CCMPApi *)api apiKeyForOperation:(Class)opClass {
    return apiKey;
}

@end
