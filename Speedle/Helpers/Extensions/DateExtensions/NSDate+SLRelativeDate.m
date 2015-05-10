//
//  NSDate+APPSRelativeDate.m
//  Wazere
//
//  Created by Vova Pogrebnyak on 10/24/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "NSDate+SLRelativeDate.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation NSDate (SLRelativeDate)

- (NSString *)distanceOfTimeInWordsToNow {
  return [self distanceOfTimeInWordsSinceDate:[NSDate date]];
}

/*
 1) if the picture was taken > 1s and <=59 sec ago than it should say “Xx sec” -
 which means that the image was taken Xx seconds ago.
 2) if the picture was taken >= 60 sec and <= 59 min ago than it should say “Xx
 min” - which means that the image was taken Xx minutes ago.
 3) if the picture was taken >= 60 min and <= 23 hours ago than it should say
 “Xx h” - which means that the image was taken Xx hours ago.
 4) if the picture was taken >=24 hours and <= 6 days 23 hours than it should
 say “Xx d” - which means that the image was taken Xx days ago.
 5) if the picture was taken >=7 days ago, than it should say “Xx w” - which
 means that the image was taken Xx weeks ago.
 */

//s, m, h, d, w, y

- (NSString *)distanceOfTimeInWordsSinceDate:(NSDate *)aDate {
  CGFloat interval = (CGFloat) [self timeIntervalSinceDate:aDate];

  NSString *timeUnit;
  NSInteger timeValue;

  if (interval < 0) {
    interval = interval * -1;
  }

  if (interval < 60) {
    timeValue = interval;
    timeUnit = @"s";

  } else if (interval < 3600) {
    NSInteger minutes = round(interval / 60);

    timeValue = minutes;
    timeUnit = @"m";

  } else if (interval < 86400) {
    NSInteger hours = round(interval / 60 / 60);

    timeValue = hours;
    timeUnit = @"h";

  } else if (interval < 604800) {
    NSInteger days = round(interval / 60 / 60 / 24);

    timeValue = days;
    timeUnit = @"d";
  } else {
    NSInteger weeks = round(interval / 60 / 60 / 24 / 7);

    timeValue = weeks;
    timeUnit = @"w";
  }

  return round(interval) == 0 ? NSLocalizedString(@"now", @"now") : [NSString stringWithFormat:@"%ld%@", (long)timeValue, timeUnit];
}

+ (NSString *)relativeDateFromString:(NSString *)createdAt {
  return [[self dateFromString:createdAt] distanceOfTimeInWordsToNow];
}

+ (NSDate *)dateFromString:(NSString *)createdAt {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    return [dateFormatter dateFromString:createdAt];
}

@end
