//
//  SLParentCollectionViewController.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm.h>
#import "SLGridCollectionViewCell.h"
#import "SLEmptyScreenView.h"

@interface SLParentCollectionViewController : UICollectionViewController <SLGridCollectionViewCellDelegate>
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) NSInteger selectedClassified;
@property (nonatomic, strong) RLMResults *classifieds;
@property (nonatomic, strong) SLEmptyScreenView *emptyScreen;

- (void)loadClassifieds;
- (SLGridCellStyle)gridCellStyleForRow:(NSInteger)row;
- (SLEmptyScreenType)emptyScreenType;
- (void)deleteSelectedClassified;
- (UIAlertController *)confirmationActionSheet;
- (void)updateEmptyScreen;
@end
