//
//  SLSessionUtility.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/8/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLSessionUtility.h"
#import "SLApiClient.h"
#import "SLUtilityFactory.h"
#import "SLAppDelegate.h"
#import "SLConstants.h"
#import <AWSCore.h>

@implementation SLSessionUtility

- (void)logOut {
    [[[SLUtilityFactory sharedInstance] facebookUtility] closeSession];
    [SLApiClient sharedClient].accessToken = nil;
    self.currentUserId = nil;
    AWSCognitoCredentialsProvider *provider = [AWSServiceManager defaultServiceManager].defaultServiceConfiguration.credentialsProvider;
    [provider clearKeychain];
    
    [[SLAppDelegate sharedInstance] showRootViewController];
}

- (NSString *)currentUserId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:SLCurrentUserDefaultsKey];
}

- (void)setCurrentUserId:(NSString *)currentUserId {
    if (currentUserId) {
        [[NSUserDefaults standardUserDefaults] setObject:currentUserId forKey:SLCurrentUserDefaultsKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:SLCurrentUserDefaultsKey];
    }
}

@end
