//
//  SLEditInfoTableTableViewController.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/21/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAdInfoTableViewController.h"

@class SLPreviewBaseViewController;

@interface SLEditInfoTableViewController : SLAdInfoTableViewController
@property (nonatomic, strong) SLAdvert *initialAdvert;
@property (nonatomic, strong) SLPreviewBaseViewController *previewController;
@end
