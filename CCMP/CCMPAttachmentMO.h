//
//  CCMPAttachmentMO.h
//  CCMP
//
//  Created by Christoph Lückler on 12.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CCMPAttachmentType) {
    CCMPAttachmentTypeUnknown = 0,
    CCMPAttachmentTypeApplication = 1,
    CCMPAttachmentTypeAudio = 2,
    CCMPAttachmentTypeExample = 3,
    CCMPAttachmentTypeImage = 4,
    CCMPAttachmentTypeMessage = 5,
    CCMPAttachmentTypeModel = 6,
    CCMPAttachmentTypeMultipart = 7,
    CCMPAttachmentTypeText = 8,
    CCMPAttachmentTypeVideo = 9
};

@interface CCMPAttachmentMO : NSManagedObject

@property (nonatomic, retain) NSNumber *attachmentId;
@property (nonatomic, retain) NSNumber *mimeType;
@property (nonatomic, retain) NSString *attachmentURL;
@property (nonatomic, retain) NSString *cacheKey;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSNumber *fileSize;

@property (nonatomic, retain) NSManagedObject *message;

+ (CCMPAttachmentType)attachmentTypeForMimeType:(NSString *)mimeType;

@end
