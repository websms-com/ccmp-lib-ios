//
//  CCMPAttachmentMO.m
//  CCMP
//
//  Created by Christoph Lückler on 12.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "CCMPAttachmentMO.h"

@implementation CCMPAttachmentMO

@dynamic attachmentId;
@dynamic mimeType;
@dynamic attachmentURL;
@dynamic cacheKey;
@dynamic fileName;
@dynamic fileSize;

@dynamic message;


#pragma mark
#pragma mark - Class mehtods

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
