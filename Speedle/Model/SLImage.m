//
//  SLImage.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/16/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLImage.h"

@implementation SLImage

+ (NSDictionary *)defaultPropertyValues {
    return @{@"URLString" : @""};
}

#pragma mark - Mapping

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             @"self": @"URLString",
             };
}

+ (NSDictionary *)JSONOutboundMappingDictionary {
    return @{
             @"URLString": @"self",
             };
}
@end
