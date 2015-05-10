//
//  SLEmptyScreenView.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/30/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SLEmptyScreenType) {
    SLEmptyScreenTypeHome,
    SLEmptyScreenTypeFavourites,
    SLEmptyScreenTypeMyAds,
    SLEmptyScreenTypeNoInternet
};

@protocol SLEmptyScreenViewDelegate <NSObject>
- (void)imageViewTapped;
@end

@interface SLEmptyScreenView : UIView
@property (nonatomic, strong) SLEmptyScreenView *customView;
@property (nonatomic, assign) SLEmptyScreenType screenType;

@property (nonatomic, weak) id<SLEmptyScreenViewDelegate> delegate;
@end
