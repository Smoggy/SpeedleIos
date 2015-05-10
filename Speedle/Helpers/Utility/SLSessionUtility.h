//
//  SLSessionUtility.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/8/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLSessionUtility : NSObject

@property (nonatomic, strong) NSString *currentUserId;

- (void)logOut;
@end
