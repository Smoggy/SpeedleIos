//
//  UIColor+SLExtensions.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/12/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "UIColor+SLExtensions.h"

@implementation UIColor (SLExtensions)

+ (UIColor *)placeholderGrayColor {
    return [UIColor colorWithRed:0.547 green:0.546 blue:0.564 alpha:1.000];
}

+ (UIColor *)textFieldDarkGrayColor {
    return [UIColor colorWithRed:0.279 green:0.303 blue:0.326 alpha:1.000];
}

+ (UIColor *)speedleDarkBlueColor {
    return [UIColor colorWithRed:0.130 green:0.420 blue:0.677 alpha:1.000];
}

+ (UIColor *)destructiveRedColor {
    return [UIColor colorWithRed:0.906 green:0.145 blue:0.180 alpha:1.000];
}

+ (UIColor *)speedleDarkGrayColor {
    return [UIColor colorWithRed:0.279 green:0.299 blue:0.337 alpha:1.000];
}

+ (UIColor *)speedleHighlightGrayColor {
    return [[self speedleDarkGrayColor] colorWithAlphaComponent:0.5];
}

+ (UIColor *)speedleHighlightLightGrayColor {
    return [UIColor colorWithRed:0.585 green:0.585 blue:0.594 alpha:0.500];
}

+ (UIColor *)speedleLightGrayColor {
    return [UIColor colorWithWhite:0.892 alpha:1.000];
}

@end
