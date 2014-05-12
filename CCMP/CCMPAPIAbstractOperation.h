//
//  CCMPAPIAbstractOperation.h
//  CCMP
//
//  Created by Christoph Lückler on 06.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

typedef NS_ENUM(NSInteger, CCMPOperationMethod) {
    CCMPOperationMethodPost,
    CCMPOperationMethodGet,
    CCMPOperationMethodPut
};

typedef NS_ENUM(NSInteger, CCMPParameterEncoding) {
    CCMPParameterEncodingPlain,
    CCMPParameterEncodingJson
};

@interface CCMPAPIAbstractOperation : NSOperation {
    NSData *requestData;
    CCMPOperationMethod method;
}

@property (nonatomic, retain) NSMutableURLRequest *request;
@property (nonatomic, retain) NSError *error;

- (id)initWithBaseUrl:(NSString *)baseUrl path:(NSString *)path method:(CCMPOperationMethod)met jsonObject:(NSDictionary *)jsonRequest apiKey:(NSString *)key;

- (id)initWithBaseUrl:(NSString *)baseUrl path:(NSString *)path method:(CCMPOperationMethod)met plainObject:(NSString *)plainObject apiKey:(NSString *)key;

- (void)requestFinishedWithResult:(id)jsonResult andStatusCode:(NSInteger)statusCode;

+ (NSString *)customUserAgent;

@end
