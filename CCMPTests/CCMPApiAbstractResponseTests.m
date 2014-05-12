//
//  CCMPApiAbstractResponse.m
//  CCMP
//
//  Created by Christoph Lückler on 07.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCMPAPIAbstractResponse.h"

@interface CCMPApiAbstractResponseTests : XCTestCase
    
@end

@implementation CCMPApiAbstractResponseTests

#pragma mark
#pragma mark - Setup / Teardown

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}


#pragma mark
#pragma mark - Tests

- (void)testClassAvailable {
    if (NSClassFromString(@"CCMPAPIAbstractResponse") == nil) {
        XCTFail(@"No implementation for CCMPAPIAbstractResponse");
    }
}

- (void)testResponseCreate {
    CCMPAPIAbstractResponse *response = [[CCMPAPIAbstractResponse alloc] initWithDictionary:@{@"key1": @"value1"}];
    response.statusCode = [NSNumber numberWithInteger:HTTPStatusCodeOK];
    
    if ([response.statusCode integerValue] != HTTPStatusCodeOK) {
        XCTFail(@"Status code was set incorrect");
    }
}

@end
