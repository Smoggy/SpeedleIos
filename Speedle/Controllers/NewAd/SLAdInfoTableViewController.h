//
//  SLNewAdTableViewController.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/9/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLParentTableViewController.h"
#import "SLAdDescriptionTableViewCell.h"

@class SLAdvert;

@interface SLAdInfoTableViewController : SLParentTableViewController 
@property (nonatomic, strong) SLAdvert *advertisement;
- (BOOL)isEnteredDataValid;
- (void)clearAllData;
- (NSString *)categoriesSegueIdentifier;
- (void)configureNavigationBarButtons;
- (SLAdDescriptionCellButtonStyle)bottomButtonStyle;
@end
