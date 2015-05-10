//
//  UIViewController+BackButtonHandler.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/9/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLBackButtonHandlerProtocol <NSObject>
@optional
- (BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (SLBackButtonHandler) <SLBackButtonHandlerProtocol>

@end
