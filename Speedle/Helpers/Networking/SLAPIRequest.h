//
//  SLAPIRequest.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SLAPIProviderRequest.h"
#import "SLApiClient.h"
#import "SLProgressHUDUpdateDelegate.h"

typedef void(^SLAPICompletionHandler)(id response, NSError *error);

@interface SLAPIRequest : NSObject <SLAPIProviderRequest>
@property (nonatomic, weak) SLApiClient *apiClient;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *errorDomain;
@property (nonatomic, strong) NSData *imageData;
@property (readonly, strong) id parameters;
@property (nonatomic, copy) SLAPICompletionHandler completionHandler;
@property (nonatomic, weak) id<SLProgressHUDUpdateDelegate> progressHUDDelegate;

- (id)initWithAction:(NSString*)action;
- (id)initWithAction:(NSString*)action params:(id)params;
- (id)initWithAction:(NSString*)action params:(id)params method:(NSString*)method;
- (id)initTokenRequestWithAction:(NSString*)action;
- (id)initTokenRequestWithAction:(NSString*)action params:(id)params;
- (id)initTokenRequestWithAction:(NSString*)action params:(id)params method:(NSString*)method;

- (void)addParameter:(NSString*)name value:(id)value;

- (NSURLSessionDataTask *)start;
- (NSURLSessionDataTask *)startWithCompetionHandler:(SLAPICompletionHandler)completionHandler;
@end
