
//
//  SLAdDescriptionTableViewCell.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/15/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAdTableViewCellValidationProtocol.h"

@class SLAdDescriptionTableViewCell;

typedef NS_ENUM(NSInteger, SLAdDescriptionCellButtonStyle) {
    SLAdDescriptionCellButtonStylePreview,
    SLAdDescriptionCellButtonStyleRemove
};

@protocol SLAdDescriptionTableViewCellDelegate <NSObject>

- (void)tableViewCell:(SLAdDescriptionTableViewCell *)cell previewButtonTapped:(UIButton *)button;

@end

@interface SLAdDescriptionTableViewCell : UITableViewCell <SLAdTableViewCellValidationProtocol>
@property (nonatomic, strong) id<SLAdDescriptionTableViewCellDelegate> delegate;
@property (nonatomic, assign) SLAdDescriptionCellButtonStyle buttonStyle;
@end
