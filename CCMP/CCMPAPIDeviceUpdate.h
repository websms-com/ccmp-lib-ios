//
//  CCMPAPIDeviceUpdate.h
//  CCMP
//
//  Created by Christoph Lückler on 07.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAbstractOperation.h"
#import "CCMPAPIAbstractResponse.h"

@interface CCMPAPIDeviceUpdateResponse : CCMPAPIAbstractResponse
@end

@interface CCMPAPIDeviceUpdateOperation : CCMPAPIAbstractOperation
@property (nonatomic, retain) CCMPAPIDeviceUpdateResponse *response;
@end