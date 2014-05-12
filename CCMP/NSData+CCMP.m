//
//  NSData+CCMP.m
//  CCMP
//
//  Created by Christoph Lückler on 20.12.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "NSData+CCMP.h"

@implementation NSData (CCMP)

- (NSString *)customBase64EncodedString {
    if ([self respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        return [self base64EncodedStringWithOptions:0];
    } else {
        return [self base64Encoding];
    }
}

@end
