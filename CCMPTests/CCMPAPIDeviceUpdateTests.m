//
//  CCMPAPIDeviceUpdateTests.m
//  CCMP
//
//  Created by Christoph Lückler on 07.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCMPAPIDeviceUpdate.h"
#import "CCMPTestConfig.h"

@interface CCMPAPIDeviceUpdateTests : XCTestCase {
    NSDictionary *requstObject;
    CCMPAPIDeviceUpdateOperation *updateOperation;
}
@end

@implementation CCMPAPIDeviceUpdateTests

#pragma mark
#pragma mark - Setup / Teardown

- (void)setUp {
    [super setUp];
    
    requstObject = @{@"deviceToken": CCMP_TEST_DEVICETOKEN,
                     @"enabled": [NSNumber numberWithBool:YES],
                     @"msisdn": [NSNumber numberWithLongLong:[CCMP_TEST_ADDRESS longLongValue]],
                     @"apiKey": CCMP_TEST_APIKEY,
                     @"pushId": CCMP_TEST_APNTOKEN,
                     @"verified": [NSNumber numberWithBool:YES]};
    
    updateOperation = [[CCMPAPIDeviceUpdateOperation alloc] initWithBaseUrl: CCMP_TEST_BASEURL
                                                                       path: [NSString stringWithFormat:@"device/%@", CCMP_TEST_DEVICETOKEN]
                                                                     method: CCMPOperationMethodPut
                                                                 jsonObject: requstObject
                                                                     apiKey: CCMP_TEST_APIKEY];
    
}

- (void)tearDown {
    requstObject = nil;
    updateOperation = nil;
    [super tearDown];
}


#pragma mark
#pragma mark - Tests

- (void)testOperationClassAvailable {
    if (NSClassFromString(@"CCMPAPIDeviceUpdateOperation") == nil) {
        XCTFail(@"No implementation for CCMPAPIDeviceUpdateOperation");
    }
}

- (void)testResponseClassAvailable {
    if (NSClassFromString(@"CCMPAPIDeviceUpdateResponse") == nil) {
        XCTFail(@"No implementation for CCMPAPIDeviceUpdateResponse");
    }
}

- (void)testResponseCreate {
    [updateOperation requestFinishedWithResult: nil
                                 andStatusCode: HTTPStatusCodeOK];
    
    CCMPAPIDeviceUpdateResponse *response = updateOperation.response;
    if (response.statusCode.integerValue != HTTPStatusCodeOK) {
        XCTFail(@"Response assertion invalid");
    }
}

@end
