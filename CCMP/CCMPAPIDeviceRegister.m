//
//  CCMPAPIDeviceRegister.m
//  CCMP
//
//  Created by Christoph Lückler on 07.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIDeviceRegister.h"

@implementation CCMPAPIDeviceRegisterResponse
@synthesize deviceToken;
@end

@implementation CCMPAPIDeviceRegisterOperation
@synthesize response;

- (void)requestFinishedWithResult:(NSDictionary *)jsonResult andStatusCode:(NSInteger)statusCode {
    [super requestFinishedWithResult:jsonResult andStatusCode:statusCode];
    
    if (statusCode == 201) {
        NSString *locationHeaderText = [jsonResult objectForKey:@"Location"];
        NSString *deviceId = [[locationHeaderText componentsSeparatedByString:@"/"] lastObject];
        
        response = [[CCMPAPIDeviceRegisterResponse alloc] initWithDictionary:@{@"deviceToken": deviceId}];
    } else {
        response = [[CCMPAPIDeviceRegisterResponse alloc] initWithDictionary:jsonResult];
    }
    
    response.statusCode = [NSNumber numberWithInteger:statusCode];
}

@end