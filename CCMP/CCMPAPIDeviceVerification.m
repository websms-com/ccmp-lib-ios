//
//  CCMPAPIDeviceVerification.m
//  CCMP
//
//  Created by Christoph Lückler on 08.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIDeviceVerification.h"

@implementation CCMPAPIDeviceVerificationResponse
@end

@implementation CCMPAPIDeviceVerificationOperation
@synthesize response;

- (void)requestFinishedWithResult:(NSDictionary *)jsonResult andStatusCode:(NSInteger)statusCode {
    [super requestFinishedWithResult:jsonResult andStatusCode:statusCode];
    
    response = [[CCMPAPIDeviceVerificationResponse alloc] initWithDictionary:jsonResult];
    response.statusCode = [NSNumber numberWithInteger:statusCode];
}

@end