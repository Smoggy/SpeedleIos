
//
//  SLCategoriesTableViewController.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/13/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLParentTableViewController.h"

@class SLAdvert;

@interface SLAdCategoriesTableViewController : SLParentTableViewController
@property (nonatomic, strong) SLAdvert *advertisement;
@end
