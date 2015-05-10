//
//  SLAPIRequest+SLAdvert.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAPIRequest.h"
#import <CoreLocation/CoreLocation.h>

@class SLAdvert, SLCategory;

@interface SLAPIRequest (SLAdvert)
+ (SLAPIRequest *)allClassifieds;
+ (SLAPIRequest *)classifiedsForCurrentLocationWithQuery:(NSString *)query category:(SLCategory *)category skip:(NSInteger)skip;
+ (SLAPIRequest *)currentUserClassifieds;
+ (SLAPIRequest *)deleteClassifiedWithId:(NSString *)classifiedId;
+ (SLAPIRequest *)postAnAbuse:(SLAdvert *)advert;
- (void)createAdvert:(SLAdvert *)advert;
- (void)updateAdvert:(SLAdvert *)advert;
@end
