//
//  CCMPAccountMO+Extensions.m
//  CCMP
//
//  Created by Christoph Lückler on 21/07/15.
//  Copyright (c) 2015 Up To Eleven. All rights reserved.
//

#import "CCMPAccountMO+Extensions.h"

@implementation CCMPAccountMO (Extensions)

- (BOOL)isAvatarLoaded {
    return (self.cacheKey == nil ? NO : YES);
}

@end
