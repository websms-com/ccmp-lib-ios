//
//  CCMPAccountMO.m
//  
//
//  Created by Christoph Lückler on 26/05/15.
//
//

#import "CCMPAccountMO.h"
#import "CCMPMessageMO.h"


@implementation CCMPAccountMO

@dynamic accountId;
@dynamic avatarURL;
@dynamic cacheKey;
@dynamic displayName;
@dynamic lastMessageDate;
@dynamic refreshTimestamp;
@dynamic message;

#pragma mark - Public methods

- (BOOL)isAvatarLoaded {
    return (self.cacheKey == nil ? NO : YES);
}

@end
