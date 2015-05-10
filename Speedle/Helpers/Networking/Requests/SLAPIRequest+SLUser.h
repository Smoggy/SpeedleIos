//
//  SLAPIRequest+SLUser.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAPIRequest.h"

@class CLLocation, SLAdvert;

@interface SLAPIRequest (SLUser)
+ (SLAPIRequest *)getCurrentUserInfo;
+ (SLAPIRequest *)updateCurrentUserInfo;
+ (SLAPIRequest *)updateUserLocation:(CLLocation *)location;
+ (SLAPIRequest *)addToFavourites:(SLAdvert *)advert;
@end
