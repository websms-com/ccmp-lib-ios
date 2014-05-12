//
//  CCMPAPIDeviceVerification.h
//  CCMP
//
//  Created by Christoph Lückler on 08.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAbstractOperation.h"
#import "CCMPAPIAbstractResponse.h"

@interface CCMPAPIDeviceVerificationResponse : CCMPAPIAbstractResponse
@end

@interface CCMPAPIDeviceVerificationOperation : CCMPAPIAbstractOperation
@property (nonatomic, retain) CCMPAPIDeviceVerificationResponse *response;
@end