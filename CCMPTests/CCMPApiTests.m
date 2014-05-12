//
//  CCMPApiTests.m
//  CCMPTests
//
//  Created by Christoph Lückler on 06.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCMPApi.h"
#import "CCMPTestConfig.h"

@interface CCMPApiTests : XCTestCase <CCMPApiDelegate> {
    CCMPApi *api;
}
@end

@implementation CCMPApiTests

#pragma mark
#pragma mark - Setup / Teardown

- (void)setUp {
    [super setUp];
    
    api = [[CCMPApi alloc] init];
    api.delegate = self;
}

- (void)tearDown {
    api = nil;
    [super tearDown];
}


#pragma mark
#pragma mark - CCMPApi delegate

- (NSString *)ccmpApi:(CCMPApi *)api apiBaseURLForOperation:(Class)opClass {
    return CCMP_TEST_BASEURL;
}

- (NSString *)ccmpApi:(CCMPApi *)api apiKeyForOperation:(Class)opClass {
    return CCMP_TEST_APIKEY;
}


#pragma mark
#pragma mark - Tests

- (void)testRegistration {
    // Register new device
    CCMPAPIDeviceRegisterOperation *registerOP = [api registerDevice:[NSNumber numberWithLongLong:[CCMP_TEST_ADDRESS longLongValue]]];
    [registerOP main];
    
    if (registerOP.response.statusCode.integerValue != HTTPStatusCodeCreated) {
        XCTFail(@"Registration Request Failed - %@", registerOP.error);
    }
    
    
    // Verify pin
    CCMPAPIDeviceVerificationOperation *verifyOP = [api verifyDevice: registerOP.response.deviceToken
                                                              andPin: CCMP_TEST_VERIFYPIN];
    [verifyOP main];
    
    if (verifyOP.response.statusCode.integerValue != HTTPStatusCodeOK) {
        XCTFail(@"Verification Request Failed - %@", verifyOP.error);
    }
    
    
    // Get device info
    CCMPAPIDeviceGetOperation *getOP = [api getDevice:registerOP.response.deviceToken];
    [getOP main];
    
    if (getOP.response.statusCode.integerValue != HTTPStatusCodeOK) {
        XCTFail(@"GetDevice Request Failed - %@", verifyOP.error);
    }
    
    XCTAssertTrue([getOP.response.apiKey isEqualToString:CCMP_TEST_APIKEY], @"ApiKey is not the same");
    XCTAssertTrue([[getOP.response.msisdn stringValue] isEqualToString:CCMP_TEST_ADDRESS], @"MSISDN is not the same");
    XCTAssertTrue([getOP.response.deviceToken isEqualToString:registerOP.response.deviceToken], @"DeviceToken is not the same");
    

    // Update device info and add pushId
    CCMPAPIDeviceUpdateOperation *updateOP = [api updateDevice: registerOP.response.deviceToken
                                                    withMSISDN: getOP.response.msisdn
                                                     andPushId: CCMP_TEST_APNTOKEN];
    [updateOP main];
    
    if (updateOP.response.statusCode.integerValue != HTTPStatusCodeOK) {
        XCTFail(@"Update Request Failed - %@", updateOP.error.localizedDescription);
    }
    
    
    // Get updated device info
    CCMPAPIDeviceGetOperation *getOP2 = [api getDevice:registerOP.response.deviceToken];
    [getOP2 main];
    
    if (getOP2.response.statusCode.integerValue != HTTPStatusCodeOK) {
        XCTFail(@"GetDevice Request Failed - %@", verifyOP.error.localizedDescription);
    }

    XCTAssertTrue([getOP2.response.apiKey isEqualToString:CCMP_TEST_APIKEY], @"ApiKey is not the same");
    XCTAssertTrue([[getOP2.response.msisdn stringValue] isEqualToString:CCMP_TEST_ADDRESS], @"MSISDN is not the same");
    XCTAssertTrue([getOP2.response.deviceToken isEqualToString:registerOP.response.deviceToken], @"DeviceToken is not the same");
    XCTAssertTrue([getOP2.response.pushId isEqualToString:CCMP_TEST_APNTOKEN], @"Updated PushId is not the same");
}

@end
