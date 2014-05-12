//
//  CCMPAPIAbstractResponse.h
//  CCMP
//
//  Created by Christoph Lückler on 07.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

@interface CCMPAPIAbstractResponse : NSObject

@property (nonatomic, retain) NSNumber *statusCode;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
