//
//  CCMPUtilsTests.m
//  CCMP
//
//  Created by Christoph Lückler on 07.05.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCMPUtils.h"

@interface CCMPUtilsTests : XCTestCase

@end

@implementation CCMPUtilsTests

#pragma mark
#pragma mark - Setup / Teardown

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}


#pragma mark
#pragma mark - Setup / Teardown

- (void)testAddressToMSISDN {
    if (![[CCMPUtils addressToMsisdn:@"+436766688000"] isEqualToNumber:[NSNumber numberWithLongLong:436766688000]]) {
        XCTFail(@"Address to MSISDN conversion invalid");
    }
}

- (void)testMSISDNToAddress {
    if (![[CCMPUtils msisdnToAddress:[NSNumber numberWithLongLong:436766688000]] isEqualToString:@"+436766688000"]) {
        XCTFail(@"MSISDN to address conversion invalid");
    }
}

- (void)testAPIDateConversion {
    NSDate *date = [CCMPUtils convertFromApiDate:[NSNumber numberWithLongLong:1399469921000]];

    if ([date timeIntervalSince1970] != 1399469921) {
        XCTFail(@"Timestamp conversion invalid");
    }
}

@end
