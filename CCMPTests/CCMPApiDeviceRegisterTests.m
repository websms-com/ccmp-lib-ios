//
//  CCMPApiDeviceRegisterTests.m
//  CCMP
//
//  Created by Christoph Lückler on 07.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCMPAPIDeviceRegister.h"
#import "CCMPTestConfig.h"

@interface CCMPApiDeviceRegisterTests : XCTestCase {
    NSDictionary *requstObject;
    CCMPAPIDeviceRegisterOperation *registerOperation;
}
@end

@implementation CCMPApiDeviceRegisterTests

#pragma mark
#pragma mark - Setup / Teardown

- (void)setUp {
    [super setUp];
    
    requstObject = @{@"msisdn": [NSNumber numberWithLongLong:[CCMP_TEST_ADDRESS longLongValue]],
                     @"apiKey": CCMP_TEST_APIKEY,
                     @"pushId": CCMP_TEST_APNTOKEN};

    registerOperation = [[CCMPAPIDeviceRegisterOperation alloc] initWithBaseUrl: CCMP_TEST_BASEURL
                                                                           path: @"device/registration/register"
                                                                         method: CCMPOperationMethodPost
                                                                     jsonObject: requstObject
                                                                         apiKey: CCMP_TEST_APIKEY];
}

- (void)tearDown {
    requstObject = nil;
    registerOperation = nil;
    [super tearDown];
}


#pragma mark
#pragma mark - Tests

- (void)testOperationClassAvailable {
    if (NSClassFromString(@"CCMPAPIDeviceRegisterOperation") == nil) {
        XCTFail(@"No implementation for CCMPAPIDeviceRegisterOperation");
    }
}

- (void)testResponseClassAvailable {
    if (NSClassFromString(@"CCMPAPIDeviceRegisterResponse") == nil) {
        XCTFail(@"No implementation for CCMPAPIDeviceRegisterResponse");
    }
}

- (void)testResponseCreate {
    NSDictionary *responseDict = @{@"Location": [NSString stringWithFormat:@"%@device/registration/register/%@", CCMP_TEST_BASEURL, CCMP_TEST_DEVICETOKEN]};
    
    [registerOperation requestFinishedWithResult: responseDict
                                   andStatusCode: HTTPStatusCodeCreated];
    
    CCMPAPIDeviceRegisterResponse *response = registerOperation.response;
    if (![response.deviceToken isEqualToString:CCMP_TEST_DEVICETOKEN] || response.statusCode.integerValue != HTTPStatusCodeCreated) {
        XCTFail(@"Response assertion invalid");
    }
}

@end
