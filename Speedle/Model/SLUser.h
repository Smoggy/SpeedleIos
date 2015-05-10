//
//  SLUser.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <Realm/Realm.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Realm+JSON/RLMObject+JSON.h>
#import "SLAdvert.h"

@interface SLUser : RLMObject
@property NSString *userId;
@property NSString *username;
@property NSString *email;
@property NSString *phoneNumber;
@property CGFloat radiusSetting;
@property RLMArray<SLAdvert> *favourites;

+ (SLUser *)currentUser;
+ (void)createOrUpdateUserWithResponse:(NSDictionary *)response;
- (void)updateUserRadiusSetting:(CGFloat)newRadius;
- (BOOL)addOrDeleteFavouriteAdvert:(SLAdvert *)advert;
@end
RLM_ARRAY_TYPE(SLUser)

/*
 {
 __v: int
 _id: int
 name: String,
 email: { type: String, lowercase: true },
 role: {
 type: String,
 default: 'user'
 },
 hashedPassword: String,
 provider: String,
 salt: String,
 facebook: {},
 twitter: {},
 google: {},
 github: {},
 classifieds : [{ type: Schema.Types.ObjectId, ref: 'Classified' }],
 location: []
 }
 */
