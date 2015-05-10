//
//  SLSessionTokenCachingStrategy.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/28/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

@interface SLSessionTokenCachingStrategy : FBSessionTokenCachingStrategy
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSArray *permissions;

- (instancetype)initWithToken:(NSString *)token permissions:(NSArray *)permissions;
@end
