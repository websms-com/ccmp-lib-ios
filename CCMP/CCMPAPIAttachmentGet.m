//
//  CCMPAPIAttachmentGet.m
//  CCMP
//
//  Created by Christoph Lückler on 20.12.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAttachmentGet.h"

@implementation CCMPAPIAttachmentGetResponse
@synthesize attachmentId, mimeType, uri, name, size;
@end

@implementation CCMPAPIAttachmentGetOperation
@synthesize response;

- (void)requestFinishedWithResult:(NSDictionary *)jsonResult andStatusCode:(NSInteger)statusCode {
    [super requestFinishedWithResult:jsonResult andStatusCode:statusCode];
    
    if (jsonResult) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        if ([jsonResult objectForKey:@"id"]) {
            [dict setObject: [jsonResult objectForKey:@"id"]
                     forKey: @"attachmentId"];
        }
        
        if ([jsonResult objectForKey:@"mimeType"]) {
            [dict setObject: [jsonResult objectForKey:@"mimeType"]
                     forKey: @"mimeType"];
        }
        
        if ([jsonResult objectForKey:@"uri"]) {
            [dict setObject: [jsonResult objectForKey:@"uri"]
                     forKey: @"uri"];
        }
        
        if ([jsonResult objectForKey:@"size"]) {
            [dict setObject: [jsonResult objectForKey:@"size"]
                     forKey: @"size"];
        }
        
        if ([jsonResult objectForKey:@"name"]) {
            [dict setObject: [jsonResult objectForKey:@"name"]
                     forKey: @"name"];
        }
        
        response = [[CCMPAPIAttachmentGetResponse alloc] initWithDictionary:dict];
    } else {
        response = [CCMPAPIAttachmentGetResponse new];
    }
   
    response.statusCode = [NSNumber numberWithInteger:statusCode];
}

@end