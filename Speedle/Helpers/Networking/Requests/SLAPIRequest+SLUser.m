//
//  SLAPIRequest+SLUser.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAPIRequest+SLUser.h"
#import "SLUser.h"
#import "SLUtilityFactory.h"

@implementation SLAPIRequest (SLUser)

+ (SLAPIRequest *)getCurrentUserInfo {
    SLAPIRequest *userRequest = [[SLAPIRequest alloc] initTokenRequestWithAction:SLAPICurrentUserKeyPath];
    userRequest.completionHandler = ^(NSDictionary *response, NSError *error){
        if (!error) {
            [SLUser createOrUpdateUserWithResponse:response];
            [[SLUtilityFactory sharedInstance] sessionUtility].currentUserId = response[SLAPIIdKey];
        } else {
            NSLog(@"Error updating user info :%@", error);
        }
    };
    return userRequest;
}

+ (SLAPIRequest *)updateCurrentUserInfo {
    NSDictionary *params = [[SLUser currentUser] JSONDictionary];
    SLAPIRequest *updateRequest = [[SLAPIRequest alloc] initTokenRequestWithAction:SLAPICurrentUserKeyPath
                                                                            params:params
                                                                            method:HTTPMethodPUT];
    return updateRequest;
}

+ (SLAPIRequest *)updateUserLocation:(CLLocation *)location {
    NSArray *params = @[ @(location.coordinate.longitude), @(location.coordinate.latitude)];
    
    SLAPIRequest *userLocationRequest = [[SLAPIRequest alloc] initTokenRequestWithAction:SLAPICurrentUserLocationKeyPath
                                                                                  params:params
                                                                                  method:HTTPMethodPUT];
    return userLocationRequest;
}

+ (SLAPIRequest *)addToFavourites:(SLAdvert *)advert {
    NSMutableArray *favourites = [[NSMutableArray alloc] initWithArray:@[advert.advertId]];
    
    for (SLAdvert *favAdvert in [SLUser currentUser].favourites) {
        if ([favourites indexOfObject:favAdvert.advertId] == NSNotFound) {
            [favourites addObject:favAdvert.advertId];
        } else {
            [favourites removeObject:favAdvert.advertId];
        }
    }
    
    SLAPIRequest *favouritesRequest = [[SLAPIRequest alloc] initTokenRequestWithAction:SLAPICurrentUserFavouritesKeyPath
                                                                                params:favourites
                                                                                method:HTTPMethodPOST];
    return favouritesRequest;
}

@end
