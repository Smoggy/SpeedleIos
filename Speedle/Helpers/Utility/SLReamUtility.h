//
//  SLReamUtility.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/29/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <RLMRealm.h>

@interface SLReamUtility : FBSessionTokenCachingStrategy
@property (nonatomic, strong, readonly) RLMRealm *inMemoryRealm;
@end
