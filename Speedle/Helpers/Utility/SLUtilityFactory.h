//
//  SLUtilityFactory.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/5/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLFacebookUtility.h"
#import "SLSessionUtility.h"
#import "SLLocationManagerUtility.h"
#import "SLTwitterUtility.h"
#import "SLReamUtility.h"
#import "SLProgressHUDUtility.h"

@interface SLUtilityFactory : NSObject

+ (SLUtilityFactory *)sharedInstance;

@property (strong, nonatomic, readonly) SLFacebookUtility *facebookUtility;
@property (strong, nonatomic, readonly) SLSessionUtility *sessionUtility;
@property (strong, nonatomic, readonly) SLLocationManagerUtility *locationUtility;
@property (strong, nonatomic, readonly) SLTwitterUtility *twitterUtility;
@property (strong, nonatomic, readonly) SLReamUtility *realmUtility;
@property (strong, nonatomic, readonly) SLProgressHUDUtility *progressHUDUtility;
@end
