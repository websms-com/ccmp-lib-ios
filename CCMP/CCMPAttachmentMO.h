//
//  CCMPAttachmentMO.h
//  
//
//  Created by Christoph Lückler on 21/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CCMPMessageMO;

@interface CCMPAttachmentMO : NSManagedObject

@property (nonatomic, retain) NSNumber * attachmentId;
@property (nonatomic, retain) NSString * attachmentURL;
@property (nonatomic, retain) NSString * cacheKey;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSNumber * fileSize;
@property (nonatomic, retain) NSNumber * mimeType;
@property (nonatomic, retain) NSSet *message;
@end

@interface CCMPAttachmentMO (CoreDataGeneratedAccessors)

- (void)addMessageObject:(CCMPMessageMO *)value;
- (void)removeMessageObject:(CCMPMessageMO *)value;
- (void)addMessage:(NSSet *)values;
- (void)removeMessage:(NSSet *)values;

@end
