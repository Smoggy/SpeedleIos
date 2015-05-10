
//
//  SLProgressHUDView.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/9/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLProgressHUDView.h"
#import <AFNetworking.h>
#import "SLAppDelegate.h"

@implementation SLProgressHUDView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (SLProgressHUDView *)progressHUD {
    SLProgressHUDView *progressHUD = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SLProgressHUDView class])
                                                                    owner:nil
                                                                  options:nil] firstObject];
    progressHUD.frame = [UIScreen mainScreen].bounds;
    return progressHUD;
}

- (void)showHUDAddedToTask:(NSURLSessionTask *)urlTask {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidResumeNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidSuspendNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidCompleteNotification object:nil];
    
    if (urlTask) {
        if (urlTask.state != NSURLSessionTaskStateCompleted) {
            if (urlTask.state == NSURLSessionTaskStateRunning) {
                [self startAnimating];
            } else {
                [self stopAnimating];
            }
            
            [notificationCenter addObserver:self selector:@selector(startAnimating) name:AFNetworkingTaskDidResumeNotification object:urlTask];
            [notificationCenter addObserver:self selector:@selector(stopAnimating) name:AFNetworkingTaskDidCompleteNotification object:urlTask];
            [notificationCenter addObserver:self selector:@selector(stopAnimating) name:AFNetworkingTaskDidSuspendNotification object:urlTask];
        }
    }
}


- (void)startAnimating {
    UIWindow *window = [SLAppDelegate sharedInstance].window;
    [window addSubview:self];
}

- (void)stopAnimating {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4f animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

@end
