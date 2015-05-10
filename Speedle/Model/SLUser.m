//
//  SLUser.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLUser.h"
#import "SLUtilityFactory.h"
#import "NSDictionary+SLAdditions.h"

@implementation SLUser

+ (NSString *)primaryKey {
    return @"userId";
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"radiusSetting": @(5.0f),
             @"phoneNumber": @"",
             @"favourites": @[],
             @"username" : @"",
             @"email" : @"",
             @"userId" : @""};
}

#pragma mark - JSON Mapping

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             @"email": @"email",
             @"name": @"username",
             @"_id": @"userId",
             @"phone": @"phoneNumber",
             @"favourites": @"favourites"
             };
}

+ (NSDictionary *)JSONOutboundMappingDictionary {
    return @{
             @"email": @"email",
             @"username": @"name",
             @"userId": @"_id",
             @"phoneNumber": @"phone"
             };
}

#pragma mark - User Info Processing

+ (SLUser *)currentUser {
    NSString *userId = [[SLUtilityFactory sharedInstance] sessionUtility].currentUserId;
    return userId.length ? [SLUser objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:userId] : nil;
}

+ (void)createOrUpdateUserWithResponse:(NSDictionary *)response {
    response = [response dictionaryByReplacingNullsWithStrings];
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [SLUser createOrUpdateInRealm:realm withJSONDictionary:response];
    [realm commitWriteTransaction];
}

- (void)updateUserRadiusSetting:(CGFloat)newRadius {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    self.radiusSetting = newRadius;
    [realm commitWriteTransaction];
}

- (BOOL)addOrDeleteFavouriteAdvert:(SLAdvert *)advert {
    RLMRealm *realm = [RLMRealm defaultRealm];
    BOOL advertDeleted = NO;
    
    [realm beginWriteTransaction];
    SLAdvert *realmAdvert = [SLAdvert createOrUpdateInRealm:realm withObject:advert];
    
    NSInteger favouriteIndex = [self.favourites indexOfObject:realmAdvert];
    
    if (favouriteIndex != NSNotFound) {
        [self.favourites removeObjectAtIndex:favouriteIndex];
        advertDeleted = YES;
    } else {
        [self.favourites addObject:realmAdvert];
    }
    
    [realm commitWriteTransaction];
    return advertDeleted;
}

@end
