//
//  CCMPAPIOutbox.m
//  CCMP
//
//  Created by Christoph Lückler on 25.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIOutbox.h"

@implementation CCMPAPIOutboxResponse
@end

@implementation CCMPAPIOutboxOperation
@synthesize response;

- (void)requestFinishedWithResult:(NSDictionary *)jsonResult andStatusCode:(NSInteger)statusCode {
    [super requestFinishedWithResult:jsonResult andStatusCode:statusCode];
    
    response = [[CCMPAPIOutboxResponse alloc] initWithDictionary:jsonResult];
    response.statusCode = [NSNumber numberWithInteger:statusCode];
}

@end