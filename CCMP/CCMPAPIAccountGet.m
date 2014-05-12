//
//  CCMPAPIAccountGet.m
//  CCMP
//
//  Created by Christoph Lückler on 18.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAccountGet.h"

@implementation CCMPAPIAccountGetResponse
@synthesize displayName, displayImageUrl;
@end

@implementation CCMPAPIAccountGetOperation
@synthesize response;

- (void)requestFinishedWithResult:(NSArray *)jsonResult andStatusCode:(NSInteger)statusCode {
    [super requestFinishedWithResult:jsonResult andStatusCode:statusCode];
    
    response = [CCMPAPIAccountGetResponse new];
    response.statusCode = [NSNumber numberWithInteger:statusCode];
    
    if (statusCode == HTTPStatusCodeOK) {
        NSMutableDictionary *config = [NSMutableDictionary new];
        for (NSDictionary *dict in jsonResult) {
            [config setObject: [dict objectForKey:@"value"]
                       forKey: [dict objectForKey:@"key"]];
        }
        
        response.displayName = [config objectForKey:@"SENDER_DISPLAY_NAME"];
        response.displayImageUrl = [config objectForKey:@"SENDER_DISPLAY_IMAGE"];
    }
}

@end