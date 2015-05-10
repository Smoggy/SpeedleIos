//
//  SLAPIRequest.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//


#import "SLAPIRequest.h"
#import "SLUtilityFactory.h"
#import <UIKit+AFNetworking.h>
#import "SLAPIRequest+SLAuthorization.h"

typedef void (^SLAPISuccessBlock)(NSURLSessionDataTask *task, id JSON);
typedef void (^SLAPIfailureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface SLAPIRequest ()
@property (readwrite, strong) id parameters;
@property (readwrite, strong) NSMutableDictionary *files;
@end

@implementation SLAPIRequest

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        self.method = HTTPMethodGET;
        self.parameters = [NSMutableDictionary dictionary];
        self.apiClient = [SLApiClient sharedClient];
    }
    return self;
}

- (id)initTokenRequestWithAction:(NSString*)action {
    self = [self initTokenRequestWithAction:action params:nil];
    return self;
}

- (id)initTokenRequestWithAction:(NSString*)action params:(id)params {
    self = [self initWithAction:action params:params];
    if (self) {
        if (self.apiClient.accessToken) {
            [self updateSessionTokenParameter];
        }
    }
    return self;
}

- (void)updateSessionTokenParameter {
    NSRange tokenRange = [self.action rangeOfString:@"access_token"];
    if (tokenRange.location != NSNotFound) {
        self.action = [self.action substringToIndex:tokenRange.location - 1];
    }
    
    self.action = [self.action stringByAppendingFormat:@"?%@=%@", @"access_token", self.apiClient.accessToken];
}

- (id)initTokenRequestWithAction:(NSString*)action params:(id)params method:(NSString*)method
{
    self = [self initTokenRequestWithAction:action params:params];
    if (self && method) {
        self.method = method;
    }
    return self;
}

- (id)initWithAction:(NSString *)action {
    self = [self initWithAction:action params:nil];
    return self;
}

- (id)initWithAction:(NSString*)action params:(id)params method:(NSString*)method {
    self = [self initWithAction:action params:params];
    if (self && method) {
        self.method = method;
    }
    return self;
}

- (id)initWithAction:(NSString*)action params:(id)params {
    self = [self init];
    if (self) {
        self.action = action;
        
        self.parameters = [params mutableCopy];
    }
    return self;
}

- (void)addParameter:(NSString*)name value:(id)value {
    if (value) {
        [self.parameters setObject:value forKey:name];
    }
}

#pragma mark - Start

- (NSURLSessionDataTask *)start {
    NSURLSessionDataTask *dataTask;
    if ([self.method isEqualToString:HTTPMethodGET]) {
        dataTask = [self getRequest];
    }
    
    if ([self.method isEqualToString:HTTPMethodPOST]) {
        if (self.imageData) {
            dataTask = [self imageUploadRequest];
        } else {
            dataTask = [self postRequest];
        }
    }
    
    if ([self.method isEqualToString:HTTPMethodDELETE]) {
        dataTask = [self deleteRequest];
    }
    
    if ([self.method isEqualToString:HTTPMethodPUT]) {
        dataTask = [self putRequest];
    }
    
    NSAssert(dataTask, @"NOT IMPLEMENTED METHOD");
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    return dataTask;
}

- (NSURLSessionDataTask *)startWithCompetionHandler:(SLAPICompletionHandler)completionHandler {
    if (self.completionHandler) {
        SLAPICompletionHandler currentHandler = self.completionHandler;
        SLAPICompletionHandler newHandler = ^(id response, NSError *error) {
            currentHandler(response, error);
            completionHandler(response, error);
        };
        self.completionHandler = newHandler;
    } else {
        self.completionHandler = completionHandler;
    }
    return [self start];
}

- (NSURLSessionDataTask *)getRequest {
    return [self.apiClient GET:self.action
                    parameters:self.parameters
                       success:[self successBlock]
                       failure:[self failureBlock]];
}

- (NSURLSessionDataTask *)postRequest {
    return [self.apiClient POST:self.action
                     parameters:self.parameters
                        success:[self successBlock]
                        failure:[self failureBlock]];
}

- (NSURLSessionDataTask *)deleteRequest {
    return [self.apiClient DELETE:self.action
                     parameters:self.parameters
                        success:[self successBlock]
                        failure:[self failureBlock]];
}

- (NSURLSessionDataTask *)putRequest {
    return [self.apiClient PUT:self.action
                       parameters:self.parameters
                          success:[self successBlock]
                          failure:[self failureBlock]];
}

- (NSURLSessionDataTask *)imageUploadRequest {
    return [self.apiClient POST:self.action
                     parameters:self.parameters
      constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
          [formData appendPartWithFileData:self.imageData
                                      name:@"photo"
                                  fileName:@"photo.png"
                                  mimeType:@"image/png"];
      }
                        success:[self successBlock]
                        failure:[self failureBlock]];
}

- (SLAPISuccessBlock)successBlock {
    SLAPISuccessBlock successBlock = ^(NSURLSessionDataTask *task, id responseObject) {
        if (self.completionHandler) {
            self.completionHandler(responseObject, nil);
        }
    };
    return successBlock;
}

- (SLAPIfailureBlock)failureBlock {
    SLAPIfailureBlock failureBlock = ^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == HTTPStatusCodeUnauthorized) {
            [[[SLUtilityFactory sharedInstance] facebookUtility] openSessionWithHandler:^(NSString *token, NSError *error) {
                if (token) {
                    [[SLAPIRequest renewAccessTokenUsingFacebookToken] startWithCompetionHandler:^(id response, NSError *error) {
                        if (!error) {
                            [SLApiClient sharedClient].accessToken = response[SLAPIIngoingToken];
                            [self updateSessionTokenParameter];
                            [self start];
                        }
                    }];
                } else {
                    [[[SLUtilityFactory sharedInstance] sessionUtility] logOut];
                }
            }];
        } else {
            if (self.completionHandler) {
                self.completionHandler([NSDictionary dictionary], error);
            }
        }
    };
    return failureBlock;
}


@end
