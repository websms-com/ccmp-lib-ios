//
//  CCMPAPIOutbox.m
//  CCMP
//
//  Created by Christoph Lückler on 25.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCMPAPIOutbox.h"
#import "CCMPTestConfig.h"

@interface CCMPAPIOutboxTests : XCTestCase {
    CCMPAPIOutboxOperation *sendOperation;
}
@end

@implementation CCMPAPIOutboxTests

#pragma mark
#pragma mark - Setup / Teardown

- (void)setUp {
    [super setUp];

    sendOperation = [[CCMPAPIOutboxOperation alloc] initWithBaseUrl: CCMP_TEST_BASEURL
                                                               path: [NSString stringWithFormat:@"device/%@/outbox", CCMP_TEST_DEVICETOKEN]
                                                             method: CCMPOperationMethodPost
                                                         jsonObject: nil
                                                             apiKey: CCMP_TEST_APIKEY];
}

- (void)tearDown {
    sendOperation = nil;
    [super tearDown];
}


#pragma mark
#pragma mark - Tests

- (void)testOperationClassAvailable {
    if (NSClassFromString(@"CCMPAPIOutboxOperation") == nil) {
        XCTFail(@"No implementation for CCMPAPIOutboxOperation");
    }
}

- (void)testResponseClassAvailable {
    if (NSClassFromString(@"CCMPAPIOutboxResponse") == nil) {
        XCTFail(@"No implementation for CCMPAPIOutboxResponse");
    }
}

- (void)testResponseCreate {
    [sendOperation requestFinishedWithResult: nil
                               andStatusCode: HTTPStatusCodeCreated];
    
    CCMPAPIOutboxResponse *response = sendOperation.response;
    if (response.statusCode.integerValue != HTTPStatusCodeCreated) {
        XCTFail(@"Response assertion invalid");
    }
}

@end