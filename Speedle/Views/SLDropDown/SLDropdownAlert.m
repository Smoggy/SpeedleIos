
//
//  SLDropdownAlert.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/13/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLDropdownAlert.h"
#import "SLFontConstants.h"
#import "UIColor+SLExtensions.h"

static const NSInteger SLDropdownViewHeight = 40;
static const CGFloat SLDropdownViewAnimationDuration = .3;
static const NSInteger SLDropdownViewXOffset = 10;
static const NSInteger SLDropdownViewYOffset = 0;
static const NSInteger SLDropdownViewDefaultDelay = 3;
static const NSInteger SLDropdownViewFontSize = 18;

@interface SLDropdownAlert()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation SLDropdownAlert

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SLDropdownViewXOffset, SLDropdownViewYOffset, frame.size.width-2*SLDropdownViewXOffset, 30)];
        [self.titleLabel setFont:[UIFont fontWithName:SLHelveticaNeueLightFontName size:SLDropdownViewFontSize]];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)hideView:(UIView *)alertView {
    if (alertView) {
        [UIView animateWithDuration:SLDropdownViewAnimationDuration animations:^{
            CGRect frame = alertView.frame;
            frame.origin.y = -SLDropdownViewHeight;
            alertView.frame = frame;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SLDropdownViewAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeView:self];
        });
    }
}

- (void)removeView:(UIView *)alertView {
    if (alertView){
        [alertView removeFromSuperview];
    }
}

+ (SLDropdownAlert *)alertView {
    SLDropdownAlert *alert = [[self alloc] initWithFrame:CGRectMake(0, -SLDropdownViewHeight, [[UIScreen mainScreen]bounds].size.width, SLDropdownViewHeight)];
    return alert;
}

- (void)showWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor {
    self.titleLabel.text = title;
    
    CGRect frame = self.titleLabel.frame;
    frame.size.height = SLDropdownViewHeight-2*SLDropdownViewYOffset;
    frame.origin.y = SLDropdownViewYOffset;
    self.titleLabel.frame = frame;
    
    if (backgroundColor) {
        self.backgroundColor = backgroundColor;
    }
    
    if (!self.superview) {
        UINavigationController *viewController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [viewController.visibleViewController.view addSubview:self];
    }
    
    [UIView animateWithDuration:SLDropdownViewAnimationDuration animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SLDropdownViewDefaultDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideView:self];
        });
    }];
}

+ (void)showWithStyle:(SLDropdownAlertStyle)alertStyle {
    [[self alertView] showWithTitle:[self titleForStyle:alertStyle] backgroundColor:[self backgroundColorForStyle:alertStyle]];
}

#pragma mark - View Info

+ (NSString *)titleForStyle:(SLDropdownAlertStyle)style {
    NSString *title = nil;
    switch (style) {
        case SLDropdownAlertStyleNoInternet:
            title = NSLocalizedString(@"No internet connection", nil);
            break;
        case SLDropdownAlertStyleError:
            title = NSLocalizedString(@"Error loading", nil);
            break;
        default:
            break;
    }
    return title;
}

+ (UIColor *)backgroundColorForStyle:(SLDropdownAlertStyle)style {
    UIColor *color = nil;
    switch (style) {
        case SLDropdownAlertStyleNoInternet:
            color = [UIColor textFieldDarkGrayColor];
            break;
        case SLDropdownAlertStyleError:
            color = [UIColor destructiveRedColor];
            break;
        default:
            break;
    }
    return color;
}

@end
