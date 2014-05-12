//
//  CCMPAPIConfigurationKey.m
//  CCMP
//
//  Created by Christoph Lückler on 21.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "CCMPAPIConfigurationKey.h"

@implementation CCMPAPIConfigurationKeyResponse
@end

@implementation CCMPAPIConfigurationKeyOperation
@synthesize response;

- (void)requestFinishedWithResult:(NSArray *)jsonResult andStatusCode:(NSInteger)statusCode {
    [super requestFinishedWithResult:jsonResult andStatusCode:statusCode];
    
    response = [CCMPAPIConfigurationKeyResponse new];
    response.statusCode = [NSNumber numberWithInteger:statusCode];
}

@end