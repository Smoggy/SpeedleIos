//
//  SLGridCollectionViewCell.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLAdvert, SLGridCollectionViewCell;

typedef NS_ENUM(NSInteger, SLGridCellStyle) {
    SLGridCellStyleEdit,
    SLGridCellStyleLike,
    SLGridCellStyleLiked,
    SLGridCellStyleFavourite
};

@protocol SLGridCollectionViewCellDelegate <NSObject>

- (void)gridCollectionViewCell:(SLGridCollectionViewCell *)cell leftButtonPressed:(UIButton *)sender;
- (void)gridCollectionViewCell:(SLGridCollectionViewCell *)cell rightButtonPressed:(UIButton *)sender;

@end

@interface SLGridCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) SLAdvert *advertisement;
@property (nonatomic, weak) id<SLGridCollectionViewCellDelegate> delegate;
@property (nonatomic, assign) SLGridCellStyle cellStyle;

- (void)startMainActivityIndicator;

@end
