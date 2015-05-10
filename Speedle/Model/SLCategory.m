//
//  SLCategory.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/13/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLCategory.h"
#import "SLCategoryId.h"

@implementation SLCategory

+ (NSString *)primaryKey {
    return @"categoryId";
}

+ (NSArray *)ignoredProperties {
    return @[@"isActive"];
}

#pragma mark - JSON Mapping

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             @"active": @"isActive",
             @"name": @"name",
             @"_id": @"categoryId"
             };
}

+ (NSDictionary *)JSONOutboundMappingDictionary {
    return @{
             @"isActive": @"active",
             @"name": @"name",
             @"categoryId": @"_id"
             };
}

#pragma mark - Category Info Processing

+ (void)createOrUpdateCategoriesWithResponse:(NSArray *)response {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    for (NSDictionary *dictionary in response) {
        SLCategory *category = [SLCategory createOrUpdateInRealm:realm withJSONDictionary:dictionary];
        SLCategoryId *categoryId = [[SLCategoryId alloc] init];
        categoryId.categoryId = category.categoryId;
        [SLCategoryId createOrUpdateInRealm:realm withObject:categoryId];
    }
    [realm commitWriteTransaction];
}

+ (void)insertCategory:(SLCategory *)category {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:category];
    [realm commitWriteTransaction];
}

@end
