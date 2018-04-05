//
//  CCMPMessageMO.h
//  
//
//  Created by Christoph Lückler on 21/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CCMPAccountMO, CCMPAttachmentMO, CCMPMessageMO;

@interface CCMPMessageMO : NSManagedObject

@property (nonatomic, retain) NSString * additionalPushParameter;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * delivered;
@property (nonatomic, retain) NSNumber * deviceMessageId;
@property (nonatomic, retain) NSNumber * expired;
@property (nonatomic, retain) NSNumber * incoming;
@property (nonatomic, retain) NSNumber * messageId;
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSString * recipient;
@property (nonatomic, retain) NSString * reference;
@property (nonatomic, retain) NSNumber * replyable;
@property (nonatomic, retain) NSNumber * sendChannel;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) CCMPAccountMO *account;
@property (nonatomic, retain) CCMPMessageMO *answer;
@property (nonatomic, retain) CCMPAttachmentMO *attachment;
@property (nonatomic, retain) CCMPMessageMO *inReplyTo;

@end
