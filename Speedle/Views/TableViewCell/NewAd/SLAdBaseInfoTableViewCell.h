
//
//  SLAdBaseInfoTableViewCell.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/9/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAdTableViewCellValidationProtocol.h"

@class SLAdBaseInfoTableViewCell, SLAdvert;

@protocol SLAdBaseInfoTableViewCellDelegate <NSObject>

- (void)tableViewCell:(SLAdBaseInfoTableViewCell *)cell advertisementImageViewTapped:(UIImageView *)imageView;
- (void)updateTableViewCellFrame:(SLAdBaseInfoTableViewCell *)cell;

@end

@interface SLAdBaseInfoTableViewCell : UITableViewCell <SLAdTableViewCellValidationProtocol>
@property (nonatomic, strong) id<SLAdBaseInfoTableViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL isExpanded;
@end
