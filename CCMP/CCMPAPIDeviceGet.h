//
//  CCMPAPIDeviceGet.h
//  CCMP
//
//  Created by Christoph Lückler on 06.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAbstractOperation.h"
#import "CCMPAPIAbstractResponse.h"

@interface CCMPAPIDeviceGetResponse : CCMPAPIAbstractResponse
@property (nonatomic, retain) NSString *deviceToken;
@property (nonatomic, retain) NSNumber *msisdn;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic, retain) NSString *pushId;
@end

@interface CCMPAPIDeviceGetOperation : CCMPAPIAbstractOperation
@property (nonatomic, retain) CCMPAPIDeviceGetResponse *response;
@end