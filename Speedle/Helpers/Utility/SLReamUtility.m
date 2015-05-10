//
//  SLReamUtility.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/29/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLReamUtility.h"

@interface SLReamUtility()
@property (nonatomic, strong, readwrite) RLMRealm *inMemoryRealm;
@end

static NSString *SLInMemoryRealmIdentifier = @"SLInMemoryRealmIdentifier";

@implementation SLReamUtility

- (instancetype)init {
    self = [super init];
    if (self) {
        self.inMemoryRealm = [RLMRealm inMemoryRealmWithIdentifier:SLInMemoryRealmIdentifier];
    }
    return self;
}

@end
