//
//  CCMPAPIDeviceVerificationTests.m
//  CCMP
//
//  Created by Christoph Lückler on 08.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCMPAPIDeviceVerification.h"
#import "CCMPTestConfig.h"

@interface CCMPAPIDeviceVerificationTests : XCTestCase {
    CCMPAPIDeviceVerificationOperation *verifyOperation;
}
@end

@implementation CCMPAPIDeviceVerificationTests

#pragma mark
#pragma mark - Setup / Teardown

- (void)setUp {
    [super setUp];
    
    verifyOperation = [[CCMPAPIDeviceVerificationOperation alloc] initWithBaseUrl: CCMP_TEST_APIKEY
                                                                             path: [NSString stringWithFormat:@"device/registration/%@/verify_pin", CCMP_TEST_DEVICETOKEN]
                                                                           method: CCMPOperationMethodPost
                                                                       jsonObject: nil
                                                                           apiKey: CCMP_TEST_VERIFYPIN];
    
}

- (void)tearDown {
    verifyOperation = nil;
    [super tearDown];
}


#pragma mark
#pragma mark - Tests

- (void)testOperationClassAvailable {
    if (NSClassFromString(@"CCMPAPIDeviceVerificationOperation") == nil) {
        XCTFail(@"No implementation for CCMPAPIDeviceVerificationOperation");
    }
}

- (void)testResponseClassAvailable {
    if (NSClassFromString(@"CCMPAPIDeviceVerificationResponse") == nil) {
        XCTFail(@"No implementation for CCMPAPIDeviceVerificationResponse");
    }
}

- (void)testResponseCreate {
    [verifyOperation requestFinishedWithResult: nil
                                 andStatusCode: HTTPStatusCodeOK];
    
    CCMPAPIDeviceVerificationResponse *response = verifyOperation.response;
    if (response.statusCode.integerValue != HTTPStatusCodeOK) {
        XCTFail(@"Response assertion invalid");
    }
}

@end
