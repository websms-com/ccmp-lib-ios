//
//  CCMPAPIAbstractOperation.m
//  CCMP
//
//  Created by Christoph Lückler on 06.11.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "CCMPAPIAbstractOperation.h"
#import <Reachability/Reachability.h>
#import <AFNetworking/AFNetworking.h>
#import <UIDevice+HardwareModel/UIDevice+HardwareModel.h>

@implementation CCMPAPIAbstractOperation
@synthesize request, error;

NSString *errorDomain = @"CCMPAPIErrorDomain";

const int kRequestRetry = 3;
const int kRequestTimeout = 15.0;

#pragma mark
#pragma mark - Initialization

- (id)initWithBaseUrl:(NSString *)baseUrl path:(NSString *)path method:(CCMPOperationMethod)met jsonObject:(NSDictionary *)jsonRequest apiKey:(NSString *)key {
    self = [super init];
    if (self) {
        method = met;
        requestData = [NSKeyedArchiver archivedDataWithRootObject:jsonRequest];
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
        [httpClient setParameterEncoding:AFJSONParameterEncoding];
        
        request = [httpClient requestWithMethod: [self methodToString:met]
                                           path: path
                                     parameters: jsonRequest];
        
        [request setValue:[CCMPAPIAbstractOperation customUserAgent] forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:key forHTTPHeaderField:@"X-Api-Key"];
        [request setTimeoutInterval:kRequestTimeout];
    }
    return self;
}

- (id)initWithBaseUrl:(NSString *)baseUrl path:(NSString *)path method:(CCMPOperationMethod)met plainObject:(NSString *)plainObject apiKey:(NSString *)key {
    self = [super init];
    if (self) {
        method = met;
        requestData = [plainObject dataUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
        [httpClient setParameterEncoding:AFJSONParameterEncoding];
        
        request = [httpClient requestWithMethod: [self methodToString:met]
                                           path: path
                                     parameters: nil];
        
        [request setValue:[CCMPAPIAbstractOperation customUserAgent] forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"text/plain; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:key forHTTPHeaderField:@"X-Api-Key"];
        [request setHTTPBody:requestData];
        [request setTimeoutInterval:kRequestTimeout];
    }
    return self;
}


#pragma mark
#pragma mark - Run cycle

- (void)main {
    LOG(@"Configure %@ ...\n\tRequest URL = %@\n\tRequest HTTP-Body = %@\n\tX-Api-Key = %@\n\tContent-Type = %@",
        NSStringFromClass([self class]),
        request.URL.absoluteURL,
        [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding],
        [request.allHTTPHeaderFields objectForKey:@"X-Api-Key"],
        [request.allHTTPHeaderFields objectForKey:@"Content-Type"]);
    
    // Check server reachability
    Reachability *reachability = [Reachability reachabilityWithHostname:[self apiDomain]];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        LOG(@"Could not reach domain = %@", [self apiDomain]);
        
        error = [NSError errorWithDomain: errorDomain
                                    code: 503
                                userInfo: @{NSLocalizedDescriptionKey: [NSHTTPURLResponse localizedStringForStatusCode:503]}];
        
        [self requestFinishedWithResult:nil andStatusCode:503];
        return;
    }

    // Send request
    LOG(@"Send %@", NSStringFromClass([self class]));
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    __block NSHTTPURLResponse *response = nil;
    NSData *responseData = nil;
    NSError *connectionError;
    
    for (NSInteger i=0; i < kRequestRetry; i++) {
        
        responseData = [NSURLConnection sendSynchronousRequest: request
                                             returningResponse: &response
                                                         error: &connectionError];
        
        if (!connectionError) {
            break;
        }
        
        LOG(@"Retry %@ because of %@", NSStringFromClass([self class]), connectionError);
        [NSThread sleepForTimeInterval:1.0];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    LOG(@"Finished %@", NSStringFromClass([self class]));
    
    // Evaluate response
    NSInteger statusCode = [response statusCode];
    
    LOG(@"PLAIN RESPONSE DATA - %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);

    if (statusCode != 200 && statusCode != 201) {
        error = [NSError errorWithDomain: errorDomain
                                    code: statusCode
                                userInfo: @{NSLocalizedDescriptionKey: [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]}];
        
        [self requestFinishedWithResult:nil andStatusCode:statusCode];
    } else if (connectionError) {
        error = connectionError;
        [self requestFinishedWithResult:nil andStatusCode:0];
    } else {
        if (method == CCMPOperationMethodPost) {
            if ([[response allHeaderFields] objectForKey:@"Location"]) {
                [self requestFinishedWithResult:[response allHeaderFields] andStatusCode:statusCode];
            } else if (!responseData || responseData.length == 0) {
                [self requestFinishedWithResult:nil andStatusCode:statusCode];
            } else {
                NSError *parseErr;
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData: responseData
                                                                            options: 0
                                                                              error: &parseErr];
                
                if (parseErr) {
                    error = parseErr;
                    [self requestFinishedWithResult:nil andStatusCode:statusCode];
                } else {
                    [self requestFinishedWithResult:responseDic andStatusCode:statusCode];
                }
            }
        } else if (method == CCMPOperationMethodGet) {
            NSError *parseErr;
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData: responseData
                                                                        options: 0
                                                                          error: &parseErr];
            
            if (parseErr) {
                error = parseErr;
                [self requestFinishedWithResult:nil andStatusCode:statusCode];
            } else {
                [self requestFinishedWithResult:responseDic andStatusCode:statusCode];
            }
        } else {
            [self requestFinishedWithResult:nil andStatusCode:statusCode];
        }
    }
}


#pragma mark
#pragma mark - Private methods

- (NSString *)methodToString:(CCMPOperationMethod)m {
    switch (m) {
        case CCMPOperationMethodGet:
            return @"GET";
            break;
        
        case CCMPOperationMethodPost:
            return @"POST";
            break;
            
        case CCMPOperationMethodPut:
            return @"PUT";
            break;
            
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType"];
            break;
    }
}

- (NSString *)apiDomain {
    NSString *requestURL = request.URL.absoluteString;
    
    if ([requestURL rangeOfString:@"http://"].location != NSNotFound) {
        requestURL = [requestURL stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    }
    
    if ([requestURL rangeOfString:@"https://"].location != NSNotFound) {
        requestURL = [requestURL stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    }
    
    if ([requestURL rangeOfString:@"/"].location != NSNotFound) {
        requestURL = [[requestURL componentsSeparatedByString:@"/"] objectAtIndex:0];
    }
    
    return requestURL;
}


#pragma mark
#pragma mark - Class methods

+ (NSString *)customUserAgent {
    // Attempt to find a name for this application
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
    if (!appName) {
        appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
    }
    
    // Attempt to find version and build number for this application
    NSString *appVersion = nil;
    NSString *marketingVersionNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *developmentVersionNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    if (marketingVersionNumber && developmentVersionNumber) {
        if ([marketingVersionNumber isEqualToString:developmentVersionNumber]) {
            appVersion = marketingVersionNumber;
        } else {
            appVersion = [NSString stringWithFormat:@"%@ rv:%@",marketingVersionNumber,developmentVersionNumber];
        }
    } else {
        appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
    }
    
    // Get device plattform
    NSString *plattform = [[UIDevice new] hardwareName];
    
    // Get device os
    NSString *systemOS = [[UIDevice currentDevice] systemVersion];
    
    // Get device language
    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    
    return [NSString stringWithFormat:@"%@ %@ (%@; iOS %@; %@)", appName, appVersion, plattform, systemOS, locale];
}


#pragma mark
#pragma mark - Methods that sould be overridden

- (void)requestFinishedWithResult:(id)jsonResult andStatusCode:(NSInteger)statusCode {
    LOG(@"%@ finished with StatusCode = %ld and Result:\n%@", NSStringFromClass([self class]), (long)statusCode, jsonResult);
}

@end
