//
//  NSException+CCMP.m
//  CCMP
//
//  Created by Christoph Lückler on 27.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "NSException+CCMP.h"

@implementation NSException (CCMP)

NSString *CCMPExceptionName = @"CCMPException";

+ (void)throwException:(NSString *)format, ... {
    va_list args;
	va_start(args, format);
    [self raise:CCMPExceptionName format:format, args];
    va_end(args);
}

@end
