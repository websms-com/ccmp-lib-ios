//
//  CCMPDatabase.m
//  CCMP
//
//  Created by Christoph Lückler on 14.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPDatabase.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>

@implementation CCMPDatabase
@synthesize delegate = _delegate;

static CCMPDatabase *sharedInstance;

#pragma mark - Initialization

+ (CCMPDatabase *)sharedDB {
	return sharedInstance ?: [self new];
}

- (id)init {
	if (sharedInstance) {
        
	} else if ((self = sharedInstance = [super init])) {
        [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"CCMPDatabase.db"];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationWillTerminate:)
                                                     name: UIApplicationWillTerminateNotification
                                                   object: nil];
	}
    
	return sharedInstance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Notifications

- (void)applicationWillTerminate:(NSNotification *)notification {
    [MagicalRecord cleanUp];
}


#pragma mark - Database operations

- (void)commit {
    [self commit:nil];
}

- (void)commit:(void(^)(BOOL success))completion {
    if (completion) {
        [[self localContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
            completion(success);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationDatabaseCommited
                                                                    object: nil];
            });
        }];
    } else {
        [[self localContext] MR_saveToPersistentStoreAndWait];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationDatabaseCommited
                                                                object: nil];
        });
    }
}

- (void)deleteObject:(id)obj {
    [obj MR_deleteInContext:[self localContext]];
}

- (void)deleteAllObjects:(Class)class {
    for (NSManagedObject *obj in [class MR_findAll]) {
        [obj MR_deleteInContext:[self localContext]];
    }
}

- (void)wipeDatabase {
    CLogInfo(@"Wipe database ...");
    [self deleteAllObjects:[CCMPMessageMO class]];
}

- (NSManagedObjectContext *)localContext {
    return [NSManagedObjectContext MR_contextForCurrentThread];
}


#pragma mark - Messages

- (CCMPMessageMO *)getMessageWithId:(NSNumber *)messageId {
    NSArray *result = [CCMPMessageMO MR_findByAttribute: @"messageId"
                                              withValue: messageId
                                              inContext: [self localContext]];
    
    return [result lastObject];
}

- (CCMPMessageMO *)getMessageWithDeviceMessageId:(NSNumber *)deviceMessageId {
    NSArray *result = [CCMPMessageMO MR_findByAttribute: @"deviceMessageId"
                                              withValue: deviceMessageId
                                              inContext: [self localContext]];
    
    return [result lastObject];
}

- (NSArray *)getAllQueuedMessages {
    NSArray *result = [CCMPMessageMO MR_findByAttribute: @"status"
                                              withValue: [NSNumber numberWithInteger:CCMPMessageStatusQueued]
                                              inContext: [self localContext]];
    
    return result;
}
    
- (NSArray *)getAllOutgoingMessages {
    return [CCMPMessageMO MR_findAllWithPredicate: [NSPredicate predicateWithFormat:@"incoming == 0"]
                                        inContext: [self localContext]];
}
    
- (NSArray *)getAllMessagesForAccount:(CCMPAccountMO *)account {
    return [CCMPMessageMO MR_findAllWithPredicate: [NSPredicate predicateWithFormat:@"account == %@", account]
                                        inContext: [self localContext]];
}

- (NSArray *)getMessageWithReferenceToDeviceMessageId:(NSNumber *)deviceId {
    if (!deviceId) {
        return nil;
    }
    
    NSArray *result = [CCMPMessageMO MR_findByAttribute: @"reference"
                                              withValue: [deviceId stringValue]
                                             andOrderBy: @"date"
                                              ascending: NO
                                              inContext: [self localContext]];
    
    return result;
}

- (CCMPMessageMO *)addMessageWithMessageId:(NSNumber *)messageId content:(NSString *)text recipient:(NSString *)sender incoming:(BOOL)incoming read:(BOOL)read status:(CCMPMessageStatus)status sendChannel:(CCMPMessageSendChannel)sendChannel date:(NSDate *)date {
    
    __block CCMPMessageMO *message;
    if (messageId) {
        message = [self getMessageWithId:messageId];
    }

    if (!message) {
        message = [CCMPMessageMO MR_createInContext:[self localContext]];
        message.messageId = messageId;
        message.deviceMessageId = [CCMPUserDefaults nextDeviceMessageId];
        message.content = text;
        message.recipient = sender;
        message.date = date;
        message.incoming = [NSNumber numberWithBool:incoming];
        message.read = [NSNumber numberWithBool:read];
        message.status = [NSNumber numberWithInteger:status];
        message.sendChannel = [NSNumber numberWithInteger:sendChannel];
        
        if ([_delegate respondsToSelector:@selector(database:setReferenceForMessage:)]) {
            message.reference = [_delegate database:self setReferenceForMessage:message];
        }
        
        CLogDebug(@"Insert new message - %@", message);
        
        [self updateBadgeCounter];
        
        if ([_delegate respondsToSelector:@selector(database:shouldInsertMessage:)]) {
            [_delegate database:self shouldInsertMessage:message];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName: CCMPNotificationMessageInserted
                                                                    object: message];
            });
        }
    } else {
        [self updateMessage:message content:text read:read status:status sendChannel:sendChannel];
    }
    
    return message;
}

- (CCMPMessageMO *)updateMessage:(CCMPMessageMO *)msg content:(NSString *)text read:(BOOL)read status:(CCMPMessageStatus)status sendChannel:(CCMPMessageSendChannel)channel {

    // Get message in current context to prevent multithreading issue
    CCMPMessageMO *message = [msg MR_inContext:[self localContext]];
    
    if (text) {
        message.content = text;
    }
    
    message.read = [NSNumber numberWithBool:read];
    message.status = [NSNumber numberWithInteger:status];
    message.sendChannel = [NSNumber numberWithInteger:channel];
    
    CLogDebug(@"Update message - %@", message);
    
    [self updateBadgeCounter];
    
    return message;
}

- (CCMPMessageMO *)updateMessage:(CCMPMessageMO *)msg read:(BOOL)read {
    CCMPMessageMO *message = [msg MR_inContext:[self localContext]];
    
    message.read = [NSNumber numberWithBool:read];
    
    CLogDebug(@"Update message - %@", message);
    
    [self updateBadgeCounter];
    
    return message;
}

- (void)deleteMessageWithMessageId:(NSNumber *)messageId {
    CCMPMessageMO *message = [self getMessageWithId:messageId];
    if (message) {
        [self deleteObject:message];
    }
    
    [self updateBadgeCounter];
}

- (void)deleteMessageWithMessageIds:(NSArray *)messageIds {
    for (NSNumber *messageId in messageIds) {
        CCMPMessageMO *message = [self getMessageWithId:messageId];
        if (message) {
            [self deleteObject:message];
        }
    }
    
    [self updateBadgeCounter];
}

- (void)deleteMessage:(CCMPMessageMO *)message andReferences:(BOOL)references {
    if (!message) {
        return;
    }
    
    if (references) {
        NSArray *referencedMessages = [self getMessageWithReferenceToDeviceMessageId:message.deviceMessageId];
        for (CCMPMessageMO *msg in referencedMessages) {
            [msg MR_deleteInContext:[self localContext]];
        }
    }
    
    [message MR_deleteInContext:[self localContext]];
    
    [self updateBadgeCounter];
}

- (void)deleteAllMessagesForAccount:(CCMPAccountMO *)account deleteAccount:(BOOL)del {
    for (CCMPMessageMO *message in [self getAllMessagesForAccount:account]) {
        [message MR_deleteInContext:[self localContext]];
    }
    
    if (del) {
        [account MR_deleteInContext:[self localContext]];
    }
    
    [self updateBadgeCounter];
}

- (NSFetchedResultsController *)messageResultControllerWithOutgoing:(BOOL)outgoing {
    
    NSPredicate *predicate = nil;
    if (!outgoing) {
        predicate = [NSPredicate predicateWithFormat:@"incoming = 1"];
    }
    
    NSFetchedResultsController *ctrl = [CCMPMessageMO MR_fetchAllSortedBy: @"date"
                                                                ascending: NO
                                                            withPredicate: predicate
                                                                  groupBy: nil
                                                                 delegate: nil];
    
    return ctrl;
}
    
- (NSFetchedResultsController *)messagesResultControllerForAccount:(CCMPAccountMO *)account {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"account == %@", account];
    
    NSFetchedResultsController *ctrl = [CCMPMessageMO MR_fetchAllGroupedBy: @"sectionGroupString"
                                                             withPredicate: predicate
                                                                  sortedBy: @"date"
                                                                 ascending: YES];
    
    return ctrl;
}

- (NSUInteger)unreadMessagesCount {
    return [CCMPMessageMO MR_countOfEntitiesWithPredicate: [NSPredicate predicateWithFormat:@"incoming = 1 AND read = 0"]
                                                inContext: [self localContext]];
}


#pragma mark - Account

- (CCMPAccountMO *)getAccountWithId:(NSNumber *)accountId {
    NSArray *result = [CCMPAccountMO MR_findByAttribute: @"accountId"
                                              withValue: accountId];
    
    return [result lastObject];
}

- (CCMPAccountMO *)addAccountWithId:(NSNumber *)accountId displayName:(NSString *)name avatarURL:(NSURL *)url {
    
    __block CCMPAccountMO *account;
    if (accountId) {
        account = [self getAccountWithId:accountId];
    }
    
    if (!account) {
        account = [CCMPAccountMO MR_createInContext:[self localContext]];
        account.accountId = accountId;
        
        CLogDebug(@"Insert new account - %@", accountId);
    }
    
    account.displayName = name;
    account.avatarURL = [url absoluteString];
    
    return account;
}


#pragma mark - Attachments

- (CCMPAttachmentMO *)getAttachmentForAttachmentId:(NSNumber *)attachment {
    NSArray *result = [CCMPAttachmentMO MR_findByAttribute: @"attachmentId"
                                                 withValue: attachment];
    
    return [result lastObject];
}

- (CCMPAttachmentMO *)addAttachmentWithAttachmentId:(NSNumber *)attachmentId fileName:(NSString *)fileName fileSize:(NSNumber *)fileSize mimeType:(CCMPAttachmentType)type url:(NSURL *)url {
    
    __block CCMPAttachmentMO *attachment;
    if (attachmentId) {
        attachment = [self getAttachmentForAttachmentId:attachmentId];
    }
    
    if (!attachment) {
        attachment = [CCMPAttachmentMO MR_createInContext:[self localContext]];
        attachment.attachmentId = attachmentId;

        CLogDebug(@"Insert new attachment - %@", attachmentId);
    }
    
    attachment.fileName = fileName;
    attachment.fileSize = fileSize;
    attachment.mimeType = [NSNumber numberWithInteger:type];
    attachment.attachmentURL = [url absoluteString];
    
    return attachment;
}


#pragma mark - Private methods

- (void)updateBadgeCounter {
    NSUInteger unreadCount = [self unreadMessagesCount];
    
    CLogInfo(@"Set badge counter %d", (int)unreadCount);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:unreadCount];
}

@end
