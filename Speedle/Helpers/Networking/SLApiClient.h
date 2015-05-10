//
//  SLApiClient.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "SLAPIConstants.h"
#import "SLHTTPConstants.h"

@interface SLApiClient : AFHTTPSessionManager

@property (nonatomic, strong) NSString *accessToken;

+ (instancetype)sharedClient;
+ (BOOL)isReachable;
- (void)renewCredentials;

@end
