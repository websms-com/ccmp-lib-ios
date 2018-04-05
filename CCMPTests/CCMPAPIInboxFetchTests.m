//
//  CCMPAPIInboxFetch.m
//  CCMP
//
//  Created by Christoph Lückler on 25.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCMPAPIInbox.h"
#import "CCMPTestConfig.h"

@interface CCMPAPIInboxFetchTests : XCTestCase {
    CCMPAPIInboxFetchOperation *fetchOperation;
}
@end

@implementation CCMPAPIInboxFetchTests

#pragma mark
#pragma mark - Setup / Teardown

- (void)setUp {
    [super setUp];

    fetchOperation = [[CCMPAPIInboxFetchOperation alloc] initWithBaseUrl: CCMP_TEST_BASEURL
                                                                    path: [NSString stringWithFormat:@"device/%@/inbox/fetch", CCMP_TEST_DEVICETOKEN]
                                                                  method: CCMPOperationMethodPost
                                                              jsonObject: nil
                                                                  apiKey: CCMP_TEST_APIKEY];
}

- (void)tearDown {
    fetchOperation = nil;
    [super tearDown];
}


#pragma mark
#pragma mark - Tests

- (void)testOperationClassAvailable {
    if (NSClassFromString(@"CCMPAPIInboxFetchOperation") == nil) {
        XCTFail(@"No implementation for CCMPAPIInboxFetchOperation");
    }
}

- (void)testResponseClassAvailable {
    if (NSClassFromString(@"CCMPAPIInboxFetchResponse") == nil) {
        XCTFail(@"No implementation for CCMPAPIInboxFetchResponse");
    }
}

- (void)testResponseCreate {
    NSArray *responseObj = @[@{@"id": [NSNumber numberWithInt:4711],
                               @"createdOn": [NSNumber numberWithInt:613008000],
                               @"content": @"apple test 1",},
                             @{@"id": [NSNumber numberWithInt:4712],
                               @"createdOn": [NSNumber numberWithInt:0],
                               @"content": @"apple test 2",}];
    
    [fetchOperation requestFinishedWithResult: responseObj
                                andStatusCode: HTTPStatusCodeOK];
    
    CCMPAPIInboxFetchResponse *response = fetchOperation.response;
    if (response.statusCode.integerValue != HTTPStatusCodeOK) {
        XCTFail(@"Response assertion invalid");
    } else if ([response.messages count] != 2) {
        XCTFail(@"JSON -> Object conversion issue");
    }
}

@end
