//
//  CCMPAPIAttachmentUpload.h
//  CCMP
//
//  Created by Christoph Lückler on 20.12.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAbstractOperation.h"
#import "CCMPAPIAbstractResponse.h"

@interface CCMPAPIAttachmentUploadResponse : CCMPAPIAbstractResponse
@property (nonatomic, retain) NSNumber *attachmentId;
@end

@interface CCMPAPIAttachmentUploadOperation : CCMPAPIAbstractOperation
@property (nonatomic, retain) CCMPAPIAttachmentUploadResponse *response;
@end