//
//  CCMPAPIAttachmentGet.h
//  CCMP
//
//  Created by Christoph Lückler on 20.12.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAbstractOperation.h"
#import "CCMPAPIAbstractResponse.h"

@interface CCMPAPIAttachmentGetResponse : CCMPAPIAbstractResponse
@property (nonatomic, retain) NSNumber *attachmentId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *size;
@property (nonatomic, retain) NSString *mimeType;
@property (nonatomic, retain) NSString *uri;
@end

@interface CCMPAPIAttachmentGetOperation : CCMPAPIAbstractOperation
@property (nonatomic, retain) CCMPAPIAttachmentGetResponse *response;
@end