//
//  CCMPAPIConfiguration.h
//  CCMP
//
//  Created by Christoph Lückler on 25.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAbstractOperation.h"
#import "CCMPAPIAbstractResponse.h"

@interface CCMPAPIConfigurationResponse : CCMPAPIAbstractResponse
@property (nonatomic, retain) NSDictionary *configuration;
@end

@interface CCMPAPIConfigurationOperation : CCMPAPIAbstractOperation
@property (nonatomic, retain) CCMPAPIConfigurationResponse *response;
@end