//
//  SLBeforePostPreviewViewController.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/21/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLPreviewBaseViewController.h"
#import "SLProgressHUDUpdateDelegate.h"
#import "SLAdInfoTableViewController.h"

@interface SLBeforePostPreviewViewController : SLPreviewBaseViewController
@property (weak, nonatomic) id<SLProgressHUDUpdateDelegate> progressHudDelegate;
@property (strong, nonatomic) SLAdInfoTableViewController *adInfoTableViewController;
@end
