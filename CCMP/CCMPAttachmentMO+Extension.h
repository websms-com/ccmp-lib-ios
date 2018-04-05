//
//  CCMPAttachmentMO+Extension.h
//  CCMP
//
//  Created by Christoph Lückler on 21/07/15.
//  Copyright (c) 2015 Up To Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@interface CCMPAttachmentMO (Extension)

+ (CCMPAttachmentType)attachmentTypeForMimeType:(NSString *)mimeType;

@end
