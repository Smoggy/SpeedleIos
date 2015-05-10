//
//  SLCategoryTableViewCell.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/13/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLCategoryTableViewCell.h"

@implementation SLCategoryTableViewCell

- (void)setIsChecked:(BOOL)isChecked {
    _isChecked = isChecked;
    if (isChecked) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
