//
//  SLParentCollectionViewLayout.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLParentCollectionViewLayout.h"
#import "SLCollectionViewConstants.h"

@implementation SLParentCollectionViewLayout

- (CGSize)itemSize {
    CGFloat collectionViewWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - SLSpacingBetweenCells*SLNumberOfItemsInGrid;
    CGFloat itemSideValue = collectionViewWidth/SLNumberOfItemsInGrid;
    return CGSizeMake(itemSideValue, itemSideValue);
}

- (CGFloat)minimumInteritemSpacing {
    return SLSpacingBetweenCells;
}

- (CGFloat)minimumLineSpacing {
    return SLSpacingBetweenCells;
}

@end
