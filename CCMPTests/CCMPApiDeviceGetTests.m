//
//  CCMPApiDeviceGetTests.m
//  CCMPTests
//
//  Created by Christoph Lückler on 07.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCMPAPIDeviceGet.h"
#import "CCMPTestConfig.h"

@interface CCMPApiDeviceGetTests : XCTestCase {
    CCMPAPIDeviceGetOperation *getOperation;
}
@end

@implementation CCMPApiDeviceGetTests

#pragma mark
#pragma mark - Setup / Teardown

- (void)setUp {
    [super setUp];

    getOperation = [[CCMPAPIDeviceGetOperation alloc] initWithBaseUrl: CCMP_TEST_BASEURL
                                                                 path: [NSString stringWithFormat:@"device/%@", CCMP_TEST_DEVICETOKEN]
                                                               method: CCMPOperationMethodGet
                                                           jsonObject: nil
                                                               apiKey: CCMP_TEST_APIKEY];
}

- (void)tearDown {
    getOperation = nil;
    [super tearDown];
}


#pragma mark
#pragma mark - Tests

- (void)testOperationClassAvailable {
    if (NSClassFromString(@"CCMPAPIDeviceGetOperation") == nil) {
        XCTFail(@"No implementation for CCMPAPIDeviceGetOperation");
    }
}

- (void)testResponseClassAvailable {
    if (NSClassFromString(@"CCMPAPIDeviceGetResponse") == nil) {
        XCTFail(@"No implementation for CCMPAPIDeviceGetResponse");
    }
}

- (void)testResponseCreate {
    NSDictionary *responseDict = @{@"deviceToken": CCMP_TEST_DEVICETOKEN,
                                   @"enabled": [NSNumber numberWithBool:YES],
                                   @"msisdn": [NSNumber numberWithLongLong:[CCMP_TEST_ADDRESS longLongValue]],
                                   @"apiKey": CCMP_TEST_APIKEY,
                                   @"pushId": CCMP_TEST_APNTOKEN};
    
    [getOperation requestFinishedWithResult: responseDict
                              andStatusCode: HTTPStatusCodeOK];
    
    CCMPAPIDeviceGetResponse *response = getOperation.response;
    if (![response.deviceToken isEqualToString:[responseDict objectForKey:@"deviceToken"]] ||
        response.enabled != [[responseDict objectForKey:@"enabled"] boolValue] ||
        [response.msisdn intValue] != [[responseDict objectForKey:@"msisdn"] intValue] ||
        ![response.apiKey isEqualToString:[responseDict objectForKey:@"apiKey"]] ||
        ![response.pushId isEqualToString:[responseDict objectForKey:@"pushId"]] ||
        response.statusCode.integerValue != HTTPStatusCodeOK) {
        XCTFail(@"Response assertion invalid");
    }
}

@end
