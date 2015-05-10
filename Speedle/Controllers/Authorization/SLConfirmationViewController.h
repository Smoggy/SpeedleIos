//
//  SLConfirmationViewController.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/20/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SLConfirmationViewController : UIViewController
@property (nonatomic, strong) NSDictionary<FBGraphUser> *facebookUser;
@end
