//
//  CCMPApiAbstractOperationTests.m
//  CCMP
//
//  Created by Christoph Lückler on 07.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCMPAPIAbstractOperation.h"
#import "CCMPTestConfig.h"

@interface CCMPApiAbstractOperationTests : XCTestCase

@end

@implementation CCMPApiAbstractOperationTests

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
    if (NSClassFromString(@"CCMPAPIAbstractOperation") == nil) {
        XCTFail(@"No implementation for CCMPAPIAbstractOperation");
    }
}

- (void)testJSONRequestCreate {
    CCMPAPIAbstractOperation *op = [[CCMPAPIAbstractOperation alloc] initWithBaseUrl: CCMP_TEST_BASEURL
                                                                                path: @"device/"
                                                                              method: CCMPOperationMethodGet
                                                                          jsonObject: nil
                                                                              apiKey: CCMP_TEST_APIKEY];
    
    if (!op.request) {
        XCTFail(@"Request not created");
    }
}

- (void)testJSONRequestMethod {
    CCMPAPIAbstractOperation *op = [[CCMPAPIAbstractOperation alloc] initWithBaseUrl: CCMP_TEST_BASEURL
                                                                                path: @"device/"
                                                                              method: CCMPOperationMethodGet
                                                                          jsonObject: nil
                                                                              apiKey: CCMP_TEST_APIKEY];
    
    if (![op.request.HTTPMethod isEqualToString:@"GET"]) {
        XCTFail(@"HTTPMethod invalid");
    }
}

- (void)testJSONRequestUrl {
    CCMPAPIAbstractOperation *op = [[CCMPAPIAbstractOperation alloc] initWithBaseUrl: CCMP_TEST_BASEURL
                                                                                path: @"device/"
                                                                              method: CCMPOperationMethodGet
                                                                          jsonObject: nil
                                                                              apiKey: CCMP_TEST_APIKEY];
    
    if (![op.request.URL.absoluteString isEqualToString:[NSString stringWithFormat:@"%@device/", CCMP_TEST_BASEURL]]) {
        XCTFail(@"Request url invalid");
    }
}

- (void)testPlainRequestCreate {
    CCMPAPIAbstractOperation *op = [[CCMPAPIAbstractOperation alloc] initWithBaseUrl: CCMP_TEST_BASEURL
                                                                                path: [NSString stringWithFormat:@"device/registration/%@/verify_pin/", CCMP_TEST_DEVICETOKEN]
                                                                              method: CCMPOperationMethodPost
                                                                         plainObject: CCMP_TEST_VERIFYPIN
                                                                              apiKey: CCMP_TEST_APIKEY];
    
    if (!op.request) {
        XCTFail(@"Request not created");
    }
}

- (void)testPlainRequestMethod {
    CCMPAPIAbstractOperation *op = [[CCMPAPIAbstractOperation alloc] initWithBaseUrl: CCMP_TEST_BASEURL
                                                                                path: [NSString stringWithFormat:@"device/registration/%@/verify_pin/", CCMP_TEST_DEVICETOKEN]
                                                                              method: CCMPOperationMethodPost
                                                                         plainObject: CCMP_TEST_VERIFYPIN
                                                                              apiKey: CCMP_TEST_APIKEY];
    
    if (![op.request.HTTPMethod isEqualToString:@"POST"]) {
        XCTFail(@"HTTPMethod invalid");
    }
}

- (void)testPlainRequestUrl {
    NSString *path = [NSString stringWithFormat:@"device/registration/%@/verify_pin/", CCMP_TEST_DEVICETOKEN];
    
    CCMPAPIAbstractOperation *op = [[CCMPAPIAbstractOperation alloc] initWithBaseUrl: CCMP_TEST_BASEURL
                                                                                path: path
                                                                              method: CCMPOperationMethodPost
                                                                         plainObject: CCMP_TEST_VERIFYPIN
                                                                              apiKey: CCMP_TEST_APIKEY];
    
    if (![op.request.URL.absoluteString isEqualToString:[CCMP_TEST_BASEURL stringByAppendingString:path]]) {
        XCTFail(@"Request url invalid");
    }
}

- (void)testPlainRequestContentType {
    CCMPAPIAbstractOperation *op = [[CCMPAPIAbstractOperation alloc] initWithBaseUrl: CCMP_TEST_BASEURL
                                                                                path: [NSString stringWithFormat:@"device/registration/%@/verify_pin/", CCMP_TEST_DEVICETOKEN]
                                                                              method: CCMPOperationMethodPost
                                                                         plainObject: CCMP_TEST_VERIFYPIN
                                                                              apiKey: CCMP_TEST_APIKEY];
    
    if (![[[op.request allHTTPHeaderFields] objectForKey:@"Content-Type"] isEqualToString:@"text/plain; charset=utf-8"]) {
        XCTFail(@"ContentType invalid");
    }
}

@end
