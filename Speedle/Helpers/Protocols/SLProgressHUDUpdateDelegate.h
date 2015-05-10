//
//  SLProgressHUDUpdateDelegate.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/16/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

@protocol SLProgressHUDUpdateDelegate <NSObject>

- (void)updateHUDLabelText:(NSString *)labelText;
- (void)updateHUDProgress:(CGFloat)progress;
- (void)showProgressHUD;
- (void)hideProgressHUDWithSuccess;
- (void)hideProgressHUDWithError;

@end