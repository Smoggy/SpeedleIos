//
//  SLAPIRequest+SLAuthorization.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAPIRequest.h"

@interface SLAPIRequest (SLAuthorization)

+ (SLAPIRequest *)renewAccessTokenUsingFacebookToken;

@end
