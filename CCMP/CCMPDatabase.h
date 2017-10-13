//
//  CCMPDatabase.h
//  CCMP
//
//  Created by Christoph Lückler on 14.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CCMPMessageMO.h"
#import "CCMPMessageMO+Extension.h"
#import "CCMPAccountMO.h"
#import "CCMPAccountMO+Extensions.h"
#import "CCMPAttachmentMO.h"
#import "CCMPAttachmentMO+Extension.h"

#define SharedDB [CCMPDatabase sharedDB]

@protocol CCMPDatabaseDelegate;
@interface CCMPDatabase : NSObject {}

@property (nonatomic, retain) id<NSObject, CCMPDatabaseDelegate> delegate;

+ (CCMPDatabase *)sharedDB;

/**
 * Commit current changes on the main thread to database
 */
- (void)commit;

/**
 * Commit current changes on background thread and perform completion block when finished
 *
 * @param completion This block will be executed when commit task is done
 */
- (void)commit:(void(^)(BOOL success, NSError *error))completion;

/**
 * Cleanup whole database and commit automatically
 *
 * @warning You have to call commit manually
 */
- (void)wipeDatabase;

/**
 * Return message with given messageId
 *
 * @param messageId The messageId from the ccmp
 *
 * @return The CCMPMessageMO object with the given messageId
 */
- (CCMPMessageMO *)getMessageWithId:(NSNumber *)messageId;

/**
 * Return message with given deviceMessageId
 *
 * @param deviceMessageId The deviceMessageId that will be generated locally in the application
 *
 * @return The CCMPMessageMO object with the given deviceMessageId
 */
- (CCMPMessageMO *)getMessageWithDeviceMessageId:(NSNumber *)deviceMessageId;

/**
 * Return all messages with the Status = CCMPMessageStatusQueued
 *
 * @return NSArray with CCMPMessageMO objects
 */
- (NSArray *)getAllQueuedMessages;

/**
 * Return all messages that are outgoing
 *
 * @return NSArray with CCMPMessageMO objects
 */
- (NSArray *)getAllOutgoingMessages;

/**
 * Return all messages for a given account
 *
 * @return NSArray with CCMPMessageMO objects
 */
- (NSArray *)getAllMessagesForAccount:(CCMPAccountMO *)account;

/**
 * Add new message to the local database or updates local message, when it's already in the local database
 *
 * @param messageId The messageId from the ccmp api
 * @param content The content of the message
 * @param recipient The sender of the message
 * @param incoming This flag declares if the message is incoming or outgoing
 * @param read This flag declares if the message was read already
 * @param status The status of the message
 * @param sendChannel The sendChannel of the message
 * @param date The date when the message was sent
 *
 * @return The current created CCMPMessageMO object
 */
- (CCMPMessageMO *)addMessageWithMessageId:(NSNumber *)messageId content:(NSString *)content recipient:(NSString *)recipient incoming:(BOOL)incoming read:(BOOL)read status:(CCMPMessageStatus)status sendChannel:(CCMPMessageSendChannel)sendChannel date:(NSDate *)date;

/**
 * Update message
 *
 * @param message The CCMPMessageMO object to be updated
 * @param content The content of the message
 * @param read This flag declares if the message was read already
 * @param status The status of the message
 * @param sendChannel The sendChannel of the message
 *
 * @return The current updated CCMPMessageMO object
 */
- (CCMPMessageMO *)updateMessage:(CCMPMessageMO *)message content:(NSString *)content read:(BOOL)read status:(CCMPMessageStatus)status sendChannel:(CCMPMessageSendChannel)channel;

/**
 *  Update message
 *
 *  @param READ, The read state of the message
 */
- (CCMPMessageMO *)updateMessage:(CCMPMessageMO *)msg read:(BOOL)read;

/**
 * Remove message with given messageId
 *
 * @param messageId The messageId from the ccmp
 */
- (void)deleteMessageWithMessageId:(NSNumber *)messageId;

/**
 * Remove messages with given messageId
 *
 * @param messageIds An array with messageId's
 */
- (void)deleteMessageWithMessageIds:(NSArray *)messageIds;

/**
 * Removes all messages that are referenced to the given message
 *
 * @param message The message to be deleted
 * @praam references Should also delete all references
 */
- (void)deleteMessage:(CCMPMessageMO *)message andReferences:(BOOL)references;

/**
 * Removes all messages that are referenced to the given account
 *
 * @param account The message to be deleted
 * @praam deleteAccount Should also delete the referenced account
 */
- (void)deleteAllMessagesForAccount:(CCMPAccountMO *)account deleteAccount:(BOOL)del;

/**
 * You use a fetched results controller to efficiently manage the messages returned from a database fetch request to provide data for a UITableView object.
 * 
 * @param outgoing Set to TRUE if the NSFetchedResultsController should include outgoing messages
 *
 * @return The NSFetchedResultsController for handling message objects in UITableView
 */
- (NSFetchedResultsController *)messageResultControllerWithOutgoing:(BOOL)outgoing;
    
- (NSFetchedResultsController *)messagesResultControllerForAccount:(CCMPAccountMO *)account;

/**
 * Counts all unread and incoming messages in the local database.
 *
 * @return The amount of unread messages
 */
- (NSUInteger)unreadMessagesCount;

/**
 * Get account information for an given accountId
 *
 * @param accountId The id from an account object
 */
- (CCMPAccountMO *)getAccountWithId:(NSNumber *)accountId;

/**
 * Adds or updates an account object in the database
 *
 * @param accountId The id from an account object
 * @param name The display name
 * @param url The url of the ressource file
 */
- (CCMPAccountMO *)addAccountWithId:(NSNumber *)accountId displayName:(NSString *)name avatarURL:(NSURL *)url;

/**
 * Get an attachment for an given attachment id
 *
 * @param attachmentId The id from an attachment object
 */
- (CCMPAttachmentMO *)getAttachmentForAttachmentId:(NSNumber *)attachmentId;

/**
 * Adds or updates an attachment object in the database
 *
 * @param attachmentId The id from an attachment object
 * @param type The mime type
 * @param url The url of the ressource file
 * @param fileName The name of the file
 * @param data The data object
 */
- (CCMPAttachmentMO *)addAttachmentWithAttachmentId:(NSNumber *)attachmentId fileName:(NSString *)fileName fileSize:(NSNumber *)fileSize mimeType:(CCMPAttachmentType)type url:(NSURL *)url;

@end

@protocol CCMPDatabaseDelegate
@optional
- (NSString *)database:(CCMPDatabase *)db setReferenceForMessage:(CCMPMessageMO *)message;
- (CCMPMessageMO *)database:(CCMPDatabase *)db shouldInsertMessage:(CCMPMessageMO *)message;
@end
