//
//  SLUtilityFactory.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/5/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLUtilityFactory.h"

@interface SLUtilityFactory ()

@property (strong, nonatomic) NSMutableDictionary *utilities;

@end

@implementation SLUtilityFactory

- (instancetype)init {
    self = [super init];
    if (self) {
        _utilities = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (SLUtilityFactory *)sharedInstance {
    static SLUtilityFactory *utilities;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        utilities = [[SLUtilityFactory alloc] init];
    });
    
    return utilities;
}

- (id)utilityFromPool:(Class)utilityClass {
    NSString *className = NSStringFromClass(utilityClass);
    id utility = self.utilities[className];
    if (![utility isKindOfClass:utilityClass]) {
        if (utility == nil) {
            utility = [[utilityClass alloc] init];
            self.utilities[className] = utility;
        } else {
            NSLog(@"%@", [NSError errorWithDomain:@"SLUtilityFactory"
                                             code:0
                                         userInfo:@{
                                                    NSLocalizedFailureReasonErrorKey : @"Wrong utility"
                                                    }]);
            return nil;
        }
    }
    return utility;
}

- (SLFacebookUtility *)facebookUtility {
  SLFacebookUtility *facebookUtility = [self utilityFromPool:[SLFacebookUtility class]];
  return facebookUtility;
}

- (SLSessionUtility *)sessionUtility {
    SLSessionUtility *sessionUtility = [self utilityFromPool:[SLSessionUtility class]];
    return sessionUtility;
}

- (SLLocationManagerUtility *)locationUtility {
    SLLocationManagerUtility *locationUtility = [self utilityFromPool:[SLLocationManagerUtility class]];
    return locationUtility;
}

- (SLTwitterUtility *)twitterUtility {
    SLTwitterUtility *twitterUtility = [self utilityFromPool:[SLTwitterUtility class]];
    return twitterUtility;
}

- (SLReamUtility *)realmUtility {
    SLReamUtility *realmUtility = [self utilityFromPool:[SLReamUtility class]];
    return realmUtility;
}

- (SLProgressHUDUtility *)progressHUDUtility {
    SLProgressHUDUtility *progressHUDUtility = [self utilityFromPool:[SLProgressHUDUtility class]];
    return progressHUDUtility;
}

@end
