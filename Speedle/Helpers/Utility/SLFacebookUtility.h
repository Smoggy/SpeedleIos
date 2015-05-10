//
//  SLFacebookUtility.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/5/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@class SLAdvert;

typedef void (^FacebookUtilityCompletion)(NSString *token, NSError *error);

@interface SLFacebookUtility : NSObject

@property (copy, nonatomic) FacebookUtilityCompletion handler;

- (void)openSessionWithHandler:(FacebookUtilityCompletion)handler;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;
- (void)closeSession;
- (void)shareAdvertisement:(SLAdvert *)advert;

@end
