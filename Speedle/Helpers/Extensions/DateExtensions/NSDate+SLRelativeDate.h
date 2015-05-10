//
//  NSDate+APPSRelativeDate.h
//  Wazere
//
//  Created by Vova Pogrebnyak on 10/24/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SLRelativeDate)

- (NSString *)distanceOfTimeInWordsSinceDate:(NSDate *)aDate;
- (NSString *)distanceOfTimeInWordsToNow;
+ (NSDate *)dateFromString:(NSString *)createdAt;
+ (NSString *)relativeDateFromString:(NSString *)createdAt;

@end
