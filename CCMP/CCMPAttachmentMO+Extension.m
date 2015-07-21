//
//  CCMPAttachmentMO+Extension.m
//  CCMP
//
//  Created by Christoph Lückler on 21/07/15.
//  Copyright (c) 2015 Up To Eleven. All rights reserved.
//

#import "CCMPAttachmentMO+Extension.h"

@implementation CCMPAttachmentMO (Extension)

+ (CCMPAttachmentType)attachmentTypeForMimeType:(NSString *)mimeType {
    if ([mimeType hasPrefix:@"application"]) {
        return CCMPAttachmentTypeApplication;
    } else if ([mimeType hasPrefix:@"audio"]) {
        return CCMPAttachmentTypeAudio;
    } else if ([mimeType hasPrefix:@"example"]) {
        return CCMPAttachmentTypeExample;
    } else if ([mimeType hasPrefix:@"image"]) {
        return CCMPAttachmentTypeImage;
    } else if ([mimeType hasPrefix:@"message"]) {
        return CCMPAttachmentTypeMessage;
    } else if ([mimeType hasPrefix:@"model"]) {
        return CCMPAttachmentTypeModel;
    } else if ([mimeType hasPrefix:@"multipart"]) {
        return CCMPAttachmentTypeMultipart;
    } else if ([mimeType hasPrefix:@"text"]) {
        return CCMPAttachmentTypeText;
    } else if ([mimeType hasPrefix:@"video"]) {
        return CCMPAttachmentTypeVideo;
    } else {
        return CCMPAttachmentTypeUnknown;
    }
}

@end
