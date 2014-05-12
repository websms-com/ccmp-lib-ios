//
//  CCMP.h
//  CCMP
//
//  Created by Christoph Lückler on 06.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPVariables.h"
#import "CCMPDatabase.h"

#define SharedCCMP [CCMP sharedService]
#define NewInstanceCCMP [[CCMP alloc] initWithNewInstance];

@interface CCMP : NSObject

/**
 * Enable logging. Should only be activated for debugging purpose!!
 */
@property (nonatomic, assign) BOOL enableLogging;

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
