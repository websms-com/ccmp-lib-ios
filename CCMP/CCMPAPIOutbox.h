//
//  CCMPAPIOutbox.h
//  CCMP
//
//  Created by Christoph Lückler on 25.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAbstractOperation.h"
#import "CCMPAPIAbstractResponse.h"

@interface CCMPAPIOutboxResponse : CCMPAPIAbstractResponse
@end

@interface CCMPAPIOutboxOperation : CCMPAPIAbstractOperation
@property (nonatomic, retain) CCMPAPIOutboxResponse *response;
@end