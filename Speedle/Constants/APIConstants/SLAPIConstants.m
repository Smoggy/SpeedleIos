//
//  SLConstants.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAPIConstants.h"

NSString *const SLAPIBaseURLString = @"http://api.speedle.se/";
NSInteger const SLAPIDefaultClassifiedsLimit = 18;

#pragma mark - KeyPathes
#pragma mark - Authorization

NSString *const SLAPIRenewTokenUsingFBKeyPath = @"auth/facebook/token";
NSString *const SLAPICurrentUserKeyPath = @"/api/users/me";
NSString *const SLAPICurrentUserLocationKeyPath = @"/api/users/me/location";
NSString *const SLAPICurrentUserFavouritesKeyPath = @"/api/users/me/favourites";

#pragma mark Classifieds
NSString *const SLAPIClassifiedsKeyPath = @"/api/classifieds";
NSString *const SLAPIClassifiedKeyPath = @"/api/classifieds/%@";
NSString *const SLAPIClassifiedsForUserKeyPath = @"/api/classifieds/owner/%@";
NSString *const SLAPIClassifiedsWithLocationKeyPath = @"/api/classifieds/location/%f/%f/%f";
NSString *const SLAPIClassifiedsAbuseKeyPath = @"/api/abuses";

#pragma mark Categories
NSString *const SLAPICategoriesKeyPath = @"/api/categories";

#pragma mark - Keys
#pragma mark - Authorization
NSString *const SLAPIOutgoingToken = @"access_token";
NSString *const SLAPIIngoingToken = @"token";
NSString *const SLAPIIdKey = @"_id";

#pragma mark Classifieds
NSString *const SLAPIQueryKey = @"q";
NSString *const SLAPISkipKey = @"skip";
NSString *const SLAPILimitKey = @"limit";
NSString *const SLAPIRadiusKey = @"radius";
NSString *const SLAPICategoriesKey = @"categories";
NSString *const SLAPIClassifiedKey = @"classified";

NSString *const SLAPILongitudeKey = @"longitude";
NSString *const SLAPILatitudeKey = @"latitude";
