//
//  CCMPAccountMO.h
//  CCMP
//
//  Created by Christoph Lückler on 12.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCMPAccountMO : NSManagedObject

@property (nonatomic, retain) NSNumber *accountId;
@property (nonatomic, retain) NSString *avatarURL;
@property (nonatomic, retain) NSString *cacheKey;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSDate *refreshTimestamp;
@property (nonatomic, retain) NSDate *lastMessageDate;

@property (nonatomic, retain) NSManagedObject *message;

- (BOOL)isAvatarLoaded;

@end
