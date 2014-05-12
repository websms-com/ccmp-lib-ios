//
//  CCMPAPIConfiguration.m
//  CCMP
//
//  Created by Christoph Lückler on 25.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIConfiguration.h"

@implementation CCMPAPIConfigurationResponse
@end

@implementation CCMPAPIConfigurationOperation
@synthesize response;

- (void)requestFinishedWithResult:(NSArray *)jsonResult andStatusCode:(NSInteger)statusCode {
    [super requestFinishedWithResult:jsonResult andStatusCode:statusCode];
    
    NSMutableDictionary *config = [NSMutableDictionary new];
    for (NSDictionary *dict in jsonResult) {
        [config setObject: [dict objectForKey:@"value"]
                   forKey: [dict objectForKey:@"key"]];
    }
    
    response = [CCMPAPIConfigurationResponse new];
    response.statusCode = [NSNumber numberWithInteger:statusCode];
    response.configuration = [[NSDictionary alloc] initWithDictionary:config];
}

@end