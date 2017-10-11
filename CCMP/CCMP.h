//
//  CCMP.h
//  CCMP
//
//  Created by Christoph Lückler on 06.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPVariables.h"
#import "CCMPDatabase.h"
#import <PushKit/PushKit.h>

#define SharedCCMP [CCMP sharedService]
#define NewInstanceCCMP [[CCMP alloc] initWithNewInstance];

@interface CCMP : NSObject

/**
 * API-Key for requests with the CCMP
 */
@property (nonatomic, retain) NSString *apiKey;

/**
 * API BaseURL for requests with the CCMP
 */
@property (nonatomic, retain) NSString *apiBaseURL;

/**
 * Database, to manually add/remove messages
 */
@property (nonatomic, retain) CCMPDatabase *database;


#pragma mark
#pragma mark - Initialization

/**
 * Shared instance from CCMP Object.
 *
 * @return CCMP Object
 */
+ (CCMP *)sharedService NS_AVAILABLE_IOS(3_0);

/**
 * Initializes a new instance of the CCMPLibrary
 *
 * @return CCMP Object
 */
- (id)initWithNewInstance;


#pragma mark
#pragma mark - APNS & Notification handling

/**
 * Notifies the delegate when the push credentials have been updated.
 *
 * @see didUpdatePushCredentials:
 */
- (void)didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type;

/**
 * Notifies the delegate that a remote push has been received.
 *
 * @see didReceiveIncomingPushWithPayload:
 */
- (void)didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type;

/**
 * Notifies the delegate that a remote push has been received.
 *
 * @see didReceiveIncomingPushWithPayload:
 */
- (void)didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type completionHandler:(void (^)(NSError *err))completionHandler;

/**
 * Tells the delegate that the app successfully registered with Apple Push Service (APS).
 *
 * @see didRegisterForRemoteNotificationsWithDeviceToken:
 */
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken NS_AVAILABLE_IOS(3_0);

/**
 * Sent to the delegate when Apple Push Service cannot successfully complete the registration process.
 *
 * @see didFailToRegisterForRemoteNotificationsWithError:
 */
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0);

/**
 * Tells the delegate that the running app received a remote notification.
 *
 * @see didReceiveRemoteNotification:
 */
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo NS_AVAILABLE_IOS(3_0);

/**
 * Sent to the delegate when a running app receives a local notification.
 *
 * @see didReceiveLocalNotification:
 */
- (void)didReceiveLocalNotification:(UILocalNotification *)notification NS_AVAILABLE_IOS(4_0);

/**
 * Tells the app that a push notification arrived that indicates there is data to be fetched.
 *
 * @see didReceiveRemoteNotification:fetchCompletionHandler:
 */
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler NS_AVAILABLE_IOS(7_0);

/**
 * Tells the app that a push notification action was triggered.
 * You need to handle the actions in your own app. The library only adds an entry to the log.
 * To configure the identifer please contact your websms keyaccount manager.
 *
 * @see handleActionWithIdentifier:forRemoteNotification:completionHandler:
 */
- (void)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)(void))completionHandler NS_AVAILABLE_IOS(8_0);


#pragma mark
#pragma mark - Utils

/**
 * Get information if the user has registed to the CCMP.
 *
 * @return YES/NO if the user is registered
 */
- (BOOL)isRegistered NS_AVAILABLE_IOS(3_0);

/**
 * Get information if the user accepted the APNS-Confirmation to recieve remote notifications.
 *
 * @return YES/NO if the user has enabled APNS
 */
- (BOOL)isPushEnabled NS_AVAILABLE_IOS(3_0);

/**
 * Deletes local user data
 */
- (void)logout NS_AVAILABLE_IOS(3_0);


#pragma mark
#pragma mark - Registration & Verification

/**
 * Sends a pin request to the CCMP.
 * Add Observer to CCMPNotificationSentPin to get notified when request is done.
 *
 * @param msisdn MSISDN, for example: 436766688000
 */
- (void)sendPinRequest:(NSNumber *)msisdn NS_AVAILABLE_IOS(6_0);

/**
 * Verifies a given pin on the CCMP.
 * Add Observer to CCMPNotificationVerifiedDevice to get notified when request is done.
 *
 * @warning Can throw CCMPException
 *
 * @param msisdn MSISDN, for example: 436766688000
 * @param pin PIN, for example: 1234
 */
- (void)verifyMsisdn:(NSNumber *)msisdn withPin:(NSString *)pin NS_AVAILABLE_IOS(6_0);


#pragma mark
#pragma mark - Inbox / Outbox

/**
 * Updates the local inbox.
 * Add Observer to CCMPNotificationInboxUpdated to get notified when request is done.
 *
 * @warning Can throw CCMPException
 */
- (void)updateInbox NS_AVAILABLE_IOS(6_0);

/**
 * Send message to given recipient
 * Add Observer to CCMPNotificationMessageSent to get notified when request is done.
 *
 * @warning Can throw CCMPException
 *
 * @param text TEXT, the message text
 * @param address ADDRESS, for example: 436766688000
 * @param messageId MESSAGE ID, the id of an message that acts as reply
 */
- (void)sendMessage:(NSString *)text toRecipient:(NSString *)address inReplyTo:(NSNumber *)messageId NS_AVAILABLE_IOS(6_0);

/**
 * Send message and attachment to given recipient
 * Add Observer to CCMPNotificationMessageSent to get notified when request is done.
 *
 * @warning Can throw CCMPException
 *
 * @param text TEXT, the message text
 * @param attachment ATTACHMENT, the representing NSData object of the attachment
 * @param mimeType MIMETYPE, the mimetype of the attachment
 * @param address ADDRESS, for example: 436766688000
 * @param messageId MESSAGE ID, the id of an message that acts as reply
 */
- (void)sendMessage:(NSString *)text andAttachment:(NSData *)attachment withMimeType:(NSString *)mimeType toRecipient:(NSString *)address inReplyTo:(NSNumber *)messageId NS_AVAILABLE_IOS(6_0);


@end
