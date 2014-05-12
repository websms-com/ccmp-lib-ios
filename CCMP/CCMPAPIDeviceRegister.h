//
//  CCMPAPIDeviceRegister.h
//  CCMP
//
//  Created by Christoph Lückler on 07.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAbstractOperation.h"
#import "CCMPAPIAbstractResponse.h"

@interface CCMPAPIDeviceRegisterResponse : CCMPAPIAbstractResponse
@property (nonatomic, retain) NSString *deviceToken;
@end

@interface CCMPAPIDeviceRegisterOperation : CCMPAPIAbstractOperation
@property (nonatomic, retain) CCMPAPIDeviceRegisterResponse *response;
@end