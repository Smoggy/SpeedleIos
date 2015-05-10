//
//  SLCategoryId.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 2/3/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLCategoryId.h"

@implementation SLCategoryId

+ (NSString *)primaryKey {
    return @"categoryId";
}

#pragma mark - Mapping

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             @"self": @"categoryId",
             };
}

+ (NSDictionary *)JSONOutboundMappingDictionary {
    return @{
             @"categoryId": @"self",
             };
}

@end
