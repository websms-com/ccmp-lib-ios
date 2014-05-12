//
//  CCMPAPIConfiguration.m
//  CCMP
//
//  Created by Christoph Lückler on 25.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCMPAPIConfiguration.h"
#import "CCMPTestConfig.h"

@interface CCMPAPIConfigurationTests : XCTestCase {
    CCMPAPIConfigurationOperation *configOP;
}
@end

@implementation CCMPAPIConfigurationTests

#pragma mark
#pragma mark - Setup / Teardown

- (void)setUp {
    [super setUp];

    configOP = [[CCMPAPIConfigurationOperation alloc] initWithBaseUrl: CCMP_TEST_BASEURL
                                                                 path: @"device/client/configuration/all"
                                                               method: CCMPOperationMethodGet
                                                           jsonObject: nil
                                                               apiKey: CCMP_TEST_APIKEY];
}

- (void)tearDown {
    configOP = nil;
    [super tearDown];
}


#pragma mark
#pragma mark - Tests

- (void)testOperationClassAvailable {
    if (NSClassFromString(@"CCMPAPIConfigurationOperation") == nil) {
        XCTFail(@"No implementation for CCMPAPIConfigurationOperation");
    }
}

- (void)testResponseClassAvailable {
    if (NSClassFromString(@"CCMPAPIConfigurationResponse") == nil) {
        XCTFail(@"No implementation for CCMPAPIConfigurationResponse");
    }
}

- (void)testResponseCreate {
    NSArray *responseObj = @[@{@"key": @"RECIPIENT_NATIONAL", @"value": @"43676800812400"},
                             @{@"key": @"RECIPIENT_INTERNATIONAL", @"value": @"43676800812400"}];
    
    [configOP requestFinishedWithResult: responseObj
                          andStatusCode: HTTPStatusCodeOK];
    
    CCMPAPIConfigurationResponse *response = configOP.response;
    if (response.statusCode.intValue != 200) {
        XCTFail(@"Response assertion invalid");
    } else if (![response.configuration objectForKey:@"RECIPIENT_NATIONAL"] || ![response.configuration objectForKey:@"RECIPIENT_INTERNATIONAL"]) {
        XCTFail(@"JSON -> Object conversion issue");
    }
}

@end


