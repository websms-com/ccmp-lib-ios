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
    return [self base64EncodedStringWithOptions:0];
}

@end
