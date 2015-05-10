//
//  SLProgressHUDUtility.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 2/2/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLProgressHUDUtility.h"
#import <M13ProgressHUD.h>
#import <M13ProgressViewRing.h>
#import <CoreGraphics/CoreGraphics.h>
#import "UIColor+SLExtensions.h"
#import "SLNewAdConstants.h"

@interface SLProgressHUDUtility()
@property (nonatomic, strong) M13ProgressHUD *progressHUD;
@property (nonatomic, copy) dispatch_block_t completionBlock;
@end

@implementation SLProgressHUDUtility

- (void)updateHUDWithView:(UIView *)view completionBlock:(dispatch_block_t)completion {
    self.completionBlock = completion;
    
    [self.progressHUD removeFromSuperview];
    self.progressHUD.animationPoint = CGPointMake(CGRectGetWidth(view.frame) / 2,
                                              CGRectGetHeight(view.frame) / 2);
    [view addSubview:self.progressHUD];
}

- (M13ProgressHUD *)progressHUD {
    if (!_progressHUD) {
        M13ProgressViewRing *ring = [[M13ProgressViewRing alloc] init];
        UIColor *primaryColor = [UIColor speedleDarkBlueColor];
        ring.primaryColor = primaryColor;
        ring.secondaryColor = primaryColor;
        _progressHUD = [[M13ProgressHUD alloc] initWithProgressView:ring];
        _progressHUD.progressViewSize = CGSizeMake(SLProgressViewSideValue, SLProgressViewSideValue);
        _progressHUD.hudBackgroundColor = [UIColor colorWithWhite:1.000 alpha:0.900];
        _progressHUD.primaryColor = _progressHUD.statusColor = primaryColor;
        _progressHUD.maskType = M13ProgressHUDMaskTypeSolidColor;
        _progressHUD.shouldAutorotate = NO;
    }
    return _progressHUD;
}

#pragma mark - SLProgressHUDUpdateDelegate

- (void)updateHUDLabelText:(NSString *)labelText {
    self.progressHUD.status = labelText;
}

- (void)updateHUDProgress:(CGFloat)progress {
    [self.progressHUD setProgress:progress animated:YES];
}

- (void)hideProgressHUDWithSuccess {
    [self.progressHUD performAction:M13ProgressViewActionSuccess animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.completionBlock();
        [self.progressHUD hide:YES];
        [self.progressHUD setProgress:0 animated:NO];
    });
}

- (void)hideProgressHUDWithError {
    [self.progressHUD performAction:M13ProgressViewActionFailure animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.progressHUD hide:YES];
        [self.progressHUD setProgress:0 animated:NO];
    });
}

- (void)showProgressHUD {
    [self.progressHUD performAction:M13ProgressViewActionNone animated:YES];
    [self.progressHUD show:YES];
}

@end
