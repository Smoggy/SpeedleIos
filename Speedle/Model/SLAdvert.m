//
//  SLAdvert.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAdvert.h"
#import "SLUser.h"
#import "NSDictionary+SLAdditions.h"
#import "SLAPIConstants.h"
#import "SLUtilityFactory.h"
#import "NSDate+SLRelativeDate.h"

@implementation SLAdvert

static NSInteger const SLAdMaxCategoriesCount = 3;

+ (NSString *)primaryKey {
    return @"advertId";
}

+ (NSArray *)ignoredProperties {
    return @[@"pickedImage", @"categories"];
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             @"advertInfo" : @"",
             @"isActive" : @(YES),
             @"phoneNumber" : @"",
             @"ownerName" : @"",
             @"email" : @"",
             @"currency" : @""
             };
}

#pragma mark - JSON Mapping

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             @"active": @"isActive",
             @"name": @"advertName",
             @"_id": @"advertId",
             @"info": @"advertInfo",
             @"images": @"imagesList",
             @"price": @"price",
             @"description": @"advertDescription",
             @"views": @"numberOfViews",
             @"created": @"created",
             @"lastChanged": @"lastChanged",
             @"phoneNumber" : @"phoneNumber",
             @"ownerName" : @"ownerName",
             @"email" : @"email",
             @"currency" : @"currency",
             @"owner" : @"ownerId",
             @"thumbnails" : @"thumbnailsList",
             @"categories" : @"categoriesIds"
             };
}

+ (NSDictionary *)JSONOutboundMappingDictionary {
    return @{
             @"advertName": @"name",
             @"advertId": @"_id",
             @"imagesList": @"images",
             @"price": @"price",
             @"advertDescription": @"description",
             @"phoneNumber" : @"phoneNumber",
             @"ownerName" : @"ownerName",
             @"email" : @"email",
             @"currency" : @"currency",
             @"thumbnailsList" : @"thumbnails",
             @"categoriesIds" : @"categories"
             };
}

#pragma mark - Data Processing

+ (void)insertAdvertisement:(SLAdvert *)advert {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:advert];
    [realm commitWriteTransaction];
}

+ (void)removeAdvertisement:(SLAdvert *)advert {
    [self removeAdvertisement:advert inRealm:[RLMRealm defaultRealm]];
    [self removeAdvertisement:advert inRealm:[[SLUtilityFactory sharedInstance] realmUtility].inMemoryRealm];
}

+ (void)removeAdvertisement:(SLAdvert *)advert inRealm:(RLMRealm *)realm {
    SLAdvert *advertModel = [SLAdvert objectInRealm:realm forPrimaryKey:advert.advertId];
    
    if (advertModel) {
        [realm beginWriteTransaction];
        advertModel.isActive = NO;
        [realm commitWriteTransaction];
    }
}

+ (void)createOrUpdateAdvertsWithResponse:(NSArray *)response {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    for (NSDictionary *dictionary in response) {
        [self createOrUpdateAdvertWithResponse:dictionary inRealm:realm];
    }
}

+ (void)clearInMemoryDatabase {
    RLMRealm *realm = [[SLUtilityFactory sharedInstance] realmUtility].inMemoryRealm;
    
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

+ (void)createOrUpdateInMemoryAdvertsWithResponse:(NSArray *)response {
    RLMRealm *realm = [[SLUtilityFactory sharedInstance] realmUtility].inMemoryRealm;
    
    for (NSDictionary *dictionary in response) {
        [self createOrUpdateAdvertWithResponse:dictionary inRealm:realm];
    }
}

+ (void)createOrUpdateAdvertWithResponse:(NSDictionary *)response inRealm:(RLMRealm *)realm {
    response = [response dictionaryByReplacingNullsWithStrings];
    
    if (![response[SLAPICategoriesKey] isKindOfClass:[NSArray class]]) {
        NSMutableDictionary *mutableResponse = [response mutableCopy];
        mutableResponse[SLAPICategoriesKey] = @[];
        response = [mutableResponse copy];
    }
    
    [realm beginWriteTransaction];
    [SLAdvert createOrUpdateInRealm:realm withJSONDictionary:response];
    [realm commitWriteTransaction];
}

+ (RLMResults *)currentUserAdverts {
    NSString *currentUserId = [SLUser currentUser].userId;
    
   return [[SLAdvert objectsWhere:@"ownerId == %@ AND isActive == YES", currentUserId] sortedResultsUsingProperty:@"created" ascending:NO];
}

+ (RLMResults *)allInMemoryAdverts {
    return [[SLAdvert objectsInRealm:[[SLUtilityFactory sharedInstance] realmUtility].inMemoryRealm where:@"isActive == YES"]
            sortedResultsUsingProperty:@"created"
            ascending:NO];
}

- (BOOL)updateCategoriesWithCategory:(SLCategory *)category {
    SLCategoryId *categoryId = [[SLCategoryId objectsWhere:@"categoryId == %@", category.categoryId] firstObject];
    NSInteger categoryIndex = [self.categoriesIds indexOfObject:categoryId];
    BOOL isCategoryAdded = NO;
    
    if (categoryIndex == NSNotFound) {
        if (self.categoriesIds.count < SLAdMaxCategoriesCount) {
            [self.categoriesIds addObject:categoryId];
            isCategoryAdded = YES;
        }
    } else {
        [self.categoriesIds removeObjectAtIndex:categoryIndex];
    }
    return isCategoryAdded;
}

- (NSArray *)categories {
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    RLMResults *allCategories = [SLCategory allObjects];
    
    for (SLCategoryId *categoryId in self.categoriesIds) {
        [categories addObject:[[allCategories objectsWhere:@"categoryId == %@", categoryId.categoryId] firstObject]];
    }
    
    return [categories copy];
}

@end
