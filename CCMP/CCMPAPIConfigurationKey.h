//
//  CCMPAPIConfigurationKey.h
//  CCMP
//
//  Created by Christoph Lückler on 21.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAbstractOperation.h"
#import "CCMPAPIAbstractResponse.h"

@interface CCMPAPIConfigurationKeyResponse : CCMPAPIAbstractResponse
@end

@interface CCMPAPIConfigurationKeyOperation : CCMPAPIAbstractOperation
@property (nonatomic, retain) CCMPAPIConfigurationKeyResponse *response;
@end