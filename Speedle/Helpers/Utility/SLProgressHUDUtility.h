//
//  SLProgressHUDUtility.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 2/2/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLProgressHUDUpdateDelegate.h"
#import <UIKit/UIKit.h>

@interface SLProgressHUDUtility : NSObject<SLProgressHUDUpdateDelegate>
- (void)updateHUDWithView:(UIView *)view completionBlock:(dispatch_block_t)completion;
@end
