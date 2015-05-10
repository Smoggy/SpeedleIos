//
//  SLDropdownAlert.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/13/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SLDropdownAlertStyle) {
    SLDropdownAlertStyleNoInternet,
    SLDropdownAlertStyleError
};

@interface SLDropdownAlert : UIView

+ (void)showWithStyle:(SLDropdownAlertStyle)alertStyle;

@end
