//
//  CCMPAPIAccountGet.h
//  CCMP
//
//  Created by Christoph Lückler on 18.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAbstractOperation.h"
#import "CCMPAPIAbstractResponse.h"

@interface CCMPAPIAccountGetResponse : CCMPAPIAbstractResponse
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSString *displayImageUrl;
@property (nonatomic, assign) BOOL replyable;
@end

@interface CCMPAPIAccountGetOperation : CCMPAPIAbstractOperation
@property (nonatomic, retain) CCMPAPIAccountGetResponse *response;
@end