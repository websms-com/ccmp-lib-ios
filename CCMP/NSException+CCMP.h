//
//  NSException+CCMP.h
//  CCMP
//
//  Created by Christoph Lückler on 27.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (CCMP)

+ (void)throwException:(NSString *)format, ...;

@end
