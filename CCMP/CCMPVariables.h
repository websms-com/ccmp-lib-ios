//
//  CCMPVariables.h
//  CCMP
//
//  Created by Christoph Lückler on 11.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//


extern NSString * const CCMPNotificationSentPin;
extern NSString * const CCMPNotificationVerifiedDevice;
extern NSString * const CCMPNotificationDeviceUpdated;
extern NSString * const CCMPNotificationInboxUpdated;
extern NSString * const CCMPNotificationMessageSent;
extern NSString * const CCMPNotificationMessageInserted;
extern NSString * const CCMPNotificationDatabaseCommited;
extern NSString * const CCMPNotificationAttachmentUploadFailed;

/**
 * HTTP StatusCodes for API-Requests
 */
typedef NS_ENUM(NSInteger, HTTPStatusCode) {
    HTTPStatusCodeOK = 200,
    HTTPStatusCodeCreated = 201,
    HTTPStatusCodeNoContent = 204,
    HTTPStatusCodeBadRequest = 400,
    HTTPStatusCodeForbidden = 403,
    HTTPStatusCodeNotFound = 404,
    HTTPStatusCodeInternalServerError = 500
};
