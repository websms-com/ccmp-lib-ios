//
//  CCMPAPIDeviceGet.m
//  CCMP
//
//  Created by Christoph Lückler on 06.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIDeviceGet.h"

@implementation CCMPAPIDeviceGetResponse
@synthesize apiKey, deviceToken, enabled, msisdn, pushId;
@end

@implementation CCMPAPIDeviceGetOperation
@synthesize response;

- (void)requestFinishedWithResult:(NSDictionary *)jsonResult andStatusCode:(NSInteger)statusCode {
    [super requestFinishedWithResult:jsonResult andStatusCode:statusCode];
    
    response = [[CCMPAPIDeviceGetResponse alloc] initWithDictionary:jsonResult];
    response.statusCode = [NSNumber numberWithInteger:statusCode];
}

@end