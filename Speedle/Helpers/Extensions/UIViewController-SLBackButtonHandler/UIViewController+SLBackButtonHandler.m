//
//  UIViewController+BackButtonHandler.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/9/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "UIViewController+SLBackButtonHandler.h"

@implementation UIViewController (SLBackButtonHandler)

@end

@implementation UINavigationController (ShouldPopOnBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if ([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if ([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if (shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        for (UIView *subview in [navigationBar subviews]) {
            if(subview.alpha < 1.f) {
                [UIView animateWithDuration:.25f animations:^{
                    subview.alpha = 1.f;
                }];
            }
        }
    }
    
    return NO;
}

@end
