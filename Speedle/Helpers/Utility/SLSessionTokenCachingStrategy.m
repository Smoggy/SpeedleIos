//
//  SLSessionTokenCachingStrategy.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/28/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLSessionTokenCachingStrategy.h"

@implementation SLSessionTokenCachingStrategy

- (instancetype)initWithToken:(NSString *)token permissions:(NSArray *)permissions {
    self = [super init];
    if (self) {
        self.token = token;
        self.permissions = permissions;
    }
    return self;
}

- (FBAccessTokenData *)fetchFBAccessTokenData {
    NSMutableDictionary *tokenInformationDictionary = [NSMutableDictionary new];
    
    // Expiration date
    tokenInformationDictionary[FBTokenInformationExpirationDateKey] = [NSDate dateWithTimeIntervalSinceNow: 3600];
    
    // Refresh date
    tokenInformationDictionary[FBTokenInformationRefreshDateKey] = [NSDate date];
    
    // Token key
    tokenInformationDictionary[FBTokenInformationTokenKey] = self.token;
    
    // Permissions
    tokenInformationDictionary[FBTokenInformationPermissionsKey] = self.permissions;
    
    // Login key
    tokenInformationDictionary[FBTokenInformationLoginTypeLoginKey] = @0;
    
    return [FBAccessTokenData createTokenFromDictionary: tokenInformationDictionary];
}

@end
