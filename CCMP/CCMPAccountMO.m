//
//  CCMPAccountMO.m
//  CCMP
//
//  Created by Christoph Lückler on 12.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "CCMPAccountMO.h"

@implementation CCMPAccountMO

@dynamic accountId;
@dynamic avatarURL;
@dynamic cacheKey;
@dynamic displayName;
@dynamic refreshTimestamp;

@dynamic message;


#pragma mark
#pragma mark - Public methods

- (BOOL)isAvatarLoaded {
    return (self.cacheKey == nil ? NO : YES);
}

@end
