//
//  CCMPAPIAbstractResponse.m
//  CCMP
//
//  Created by Christoph Lückler on 07.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAbstractResponse.h"

@implementation CCMPAPIAbstractResponse
@synthesize statusCode;

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        for (NSString *key in dict.allKeys) {
            if ([self respondsToSelector:NSSelectorFromString(key)]) {
                [self setValue:[dict objectForKey:key] forKey:key];
            }
        }
    }
    return self;
}

@end
