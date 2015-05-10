










































































































//
//  AppDelegate.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/5/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)showRootViewController;
+ (SLAppDelegate *)sharedInstance;
@end

