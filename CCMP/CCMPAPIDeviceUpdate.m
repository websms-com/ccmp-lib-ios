//
//  CCMPAPIDeviceUpdate.m
//  CCMP
//
//  Created by Christoph Lückler on 07.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIDeviceUpdate.h"

@implementation CCMPAPIDeviceUpdateResponse
@end

@implementation CCMPAPIDeviceUpdateOperation
@synthesize response;

- (void)requestFinishedWithResult:(NSDictionary *)jsonResult andStatusCode:(NSInteger)statusCode {
    [super requestFinishedWithResult:jsonResult andStatusCode:statusCode];
    
    response = [[CCMPAPIDeviceUpdateResponse alloc] initWithDictionary:jsonResult];
    response.statusCode = [NSNumber numberWithInteger:statusCode];
}

@end