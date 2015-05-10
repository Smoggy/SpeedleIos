//
//  SLAPIRequest+SLAuthorization.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAPIRequest+SLAuthorization.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation SLAPIRequest (SLAuthorization)

+ (SLAPIRequest *)renewAccessTokenUsingFacebookToken {
    NSDictionary *params = @{SLAPIOutgoingToken : [FBSession activeSession].accessTokenData.accessToken};
    SLAPIRequest *renewTokenRequest = [[SLAPIRequest alloc] initWithAction:SLAPIRenewTokenUsingFBKeyPath
                                                                    params:params
                                                                    method:HTTPMethodPOST];
    return renewTokenRequest;
}

@end
