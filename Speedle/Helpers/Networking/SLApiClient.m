//
//  SLApiClient.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLApiClient.h"
#import "SLConstants.h"
#import "SLAPIRequest+SLAuthorization.h"
#import "SLUtilityFactory.h"
#import "SLDropdownAlert.h"

@implementation SLApiClient
@synthesize accessToken = _accessToken;

+ (instancetype)sharedClient {
    static SLApiClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SLApiClient alloc] initWithBaseURL:[NSURL URLWithString:SLAPIBaseURLString]];
        _sharedClient.requestSerializer = [[AFJSONRequestSerializer alloc] init];
        
        NSMutableSet *acceptableContentTypes = [_sharedClient.responseSerializer.acceptableContentTypes mutableCopy];
        [acceptableContentTypes addObject:@"text/html"];
        [acceptableContentTypes addObject:@"text/plain"];
        _sharedClient.responseSerializer.acceptableContentTypes = [acceptableContentTypes copy];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(operationDidFinish:)
                                                     name:AFNetworkingTaskDidCompleteNotification
                                                   object:nil];
    });
    
    return _sharedClient;
}

- (void)renewCredentials {
    [[[SLUtilityFactory sharedInstance] facebookUtility] openSessionWithHandler:^(NSString *token, NSError *error) {
        if (token) {
            [[SLAPIRequest renewAccessTokenUsingFacebookToken] startWithCompetionHandler:^(id response, NSError *error) {
                if (!error) {
                    [SLApiClient sharedClient].accessToken = response[SLAPIIngoingToken];
                }
            }];
        }
    }];
}

- (NSString*)accessToken {
    if (!_accessToken) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:SLAccessTokenDefaultsKey];
        token = token ? token : @"";
        _accessToken = token;
    }
    return _accessToken;
}

- (void)setAccessToken:(NSString *)accessToken {
    _accessToken = accessToken;
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:SLAccessTokenDefaultsKey];
}

+ (BOOL)isReachable {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (void)operationDidFinish:(NSNotification *)notification {
    NSURLSessionTask *task = (NSURLSessionTask *)[notification object];
    NSError *error = (notification.userInfo)[AFNetworkingTaskDidCompleteErrorKey];
    NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    error = [error.domain isEqualToString:NSCocoaErrorDomain] ? nil : error;
    
    if (underlyingError.code == NSURLErrorBadServerResponse && response.statusCode != HTTPStatusCodeUnauthorized) {
        error = underlyingError;
    }
    
    if (![task isKindOfClass:[NSURLSessionTask class]]) {
        return;
    }
    if (task.error || error) {
        [SLDropdownAlert showWithStyle:[self isReachable] ? SLDropdownAlertStyleError : SLDropdownAlertStyleNoInternet];
    }
}

@end
