//
//  CCMPTests.m
//  CCMP
//
//  Created by Christoph Lückler on 11.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTAsyncTestCase.h"
#import "CCMP.h"
#import "CCMPTestConfig.h"

@interface CCMPTests : XCTAsyncTestCase {
    CCMP *ccmp;
}
@end

@implementation CCMPTests

- (void)setUp {
    [super setUp];

    ccmp = SharedCCMP;
    ccmp.apiBaseURL = CCMP_TEST_BASEURL;
    ccmp.apiKey = CCMP_TEST_APIKEY;
}

- (void)tearDown {
    ccmp = nil;
    [super tearDown];
}


#pragma mark
#pragma mark - Test Registration

- (void)testStep1SendPinRequest {
    [self prepare];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sentPinNotification:) name:CCMPNotificationSentPin object:nil];
    
    [ccmp sendPinRequest:[NSNumber numberWithLongLong:[phoneNumber longLongValue]]];

    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0];
}

- (void)testStep2VerifyPin {
    [self prepare];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifiedDeviceNotification:) name:CCMPNotificationVerifiedDevice object:nil];
    
    [ccmp verifyMsisdn: [NSNumber numberWithLongLong:[phoneNumber longLongValue]]
               withPin: verifyPin];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0];
}

- (void)testStep3IsRegistered {
    XCTAssertTrue([ccmp isRegistered], @"Registration flow incorrect");
}


#pragma mark
#pragma mark - Test send message

- (void)testStep4UpdateInbox {
    [self prepare];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inboxUpdatedNotification:) name:CCMPNotificationInboxUpdated object:nil];
    
    [ccmp updateInbox];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0];
}

- (void)testStep5SendMessage {
    [self prepare];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageSentNotification:) name:CCMPNotificationMessageSent object:nil];
    
    [ccmp sendMessage: @"UnitTest Message Sending"
          toRecipient: [NSNumber numberWithLongLong:[@"436766688650" longLongValue]]];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:30.0];
}


#pragma mark
#pragma mark - Notifications 

- (void)sentPinNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CCMPNotificationSentPin object:nil];
    
    if (!notification.object) {
        [self notify:kXCTUnitWaitStatusSuccess];
    } else {
        NSLog(@"Request failed - %@", notification.object);
        [self notify:kXCTUnitWaitStatusFailure];
    }
}

- (void)verifiedDeviceNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CCMPNotificationVerifiedDevice object:nil];
    
    if (!notification.object) {
        [self notify:kXCTUnitWaitStatusSuccess];
    } else {
        NSLog(@"Request failed - %@", notification.object);
        [self notify:kXCTUnitWaitStatusFailure];
    }
}

- (void)inboxUpdatedNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CCMPNotificationInboxUpdated object:nil];
    
    if (!notification.object) {
        [self notify:kXCTUnitWaitStatusSuccess];
    } else {
        NSLog(@"Request failed - %@", notification.object);
        [self notify:kXCTUnitWaitStatusFailure];
    }
}

- (void)messageSentNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CCMPNotificationMessageSent object:nil];
    
    CCMPMessageMO *message = notification.object;
    
    if ([message.status integerValue] == CCMPMessageStatusSent) {
        [self notify:kXCTUnitWaitStatusSuccess];
    } else {
        NSLog(@"Request failed - %@", notification.object);
        [self notify:kXCTUnitWaitStatusFailure];
    }
}

@end
