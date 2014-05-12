//
//  CCMPAPIAttachmentUpload.m
//  CCMP
//
//  Created by Christoph Lückler on 20.12.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAttachmentUpload.h"

@implementation CCMPAPIAttachmentUploadResponse
@synthesize attachmentId;
@end

@implementation CCMPAPIAttachmentUploadOperation
@synthesize response;

- (void)requestFinishedWithResult:(NSDictionary *)jsonResult andStatusCode:(NSInteger)statusCode {
    [super requestFinishedWithResult:jsonResult andStatusCode:statusCode];
    
    if (statusCode == 201) {
        NSString *locationHeaderText = [jsonResult objectForKey:@"Location"];
        NSString *attachmentKeyString = [[locationHeaderText componentsSeparatedByString:@"/"] lastObject];
        NSNumber *attachmentId = [NSNumber numberWithInt:[attachmentKeyString intValue]];
        
        response = [[CCMPAPIAttachmentUploadResponse alloc] initWithDictionary:@{@"attachmentId": attachmentId}];
    } else {
        response = [CCMPAPIAttachmentUploadResponse new];
    }
    
    response.statusCode = [NSNumber numberWithInteger:statusCode];
}

@end