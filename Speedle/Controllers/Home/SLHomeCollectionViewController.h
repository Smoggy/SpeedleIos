//
//  SLHomeCollectionViewController.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/17/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLParentCollectionViewController.h"

@class SLCategory;

@interface SLHomeCollectionViewController : SLParentCollectionViewController
@property (nonatomic, strong) SLCategory *category;
@end
