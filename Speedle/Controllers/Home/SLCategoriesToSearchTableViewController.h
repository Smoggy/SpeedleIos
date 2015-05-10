//
//  SLCategoriesToSearchTableViewController.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/22/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLParentTableViewController.h"
#import "SLHomeCollectionViewController.h"

@interface SLCategoriesToSearchTableViewController : SLParentTableViewController
@property (nonatomic, strong) SLHomeCollectionViewController *homeController;
@property (nonatomic, strong) SLCategory *selectedCategory;
@end
