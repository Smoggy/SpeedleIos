
//
//  SLEmptyScreenView.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/30/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLEmptyScreenView.h"

@interface SLEmptyScreenView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@end

@implementation SLEmptyScreenView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSString *className = NSStringFromClass([self class]);
        _customView = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        
        if (CGRectIsEmpty(frame)) {
            self.bounds = _customView.bounds;
        } else {
            _customView.frame = frame;
        }
        
        [self addSubview:_customView];
    }
    return self;
}

- (void)setScreenType:(SLEmptyScreenType)screenType {
    _screenType = screenType;
    UIImage *image = [UIImage imageNamed:@"no_ads_location_icon"];
    NSString *text = NSLocalizedString(@"There are no ads to show in this location", nil);
    
    switch (screenType) {
        case SLEmptyScreenTypeFavourites:
            image = [UIImage imageNamed:@"no_ads_favourite_icon"];
            text = NSLocalizedString(@"Your favourite ads will be displayed here", nil);
            break;
        case SLEmptyScreenTypeMyAds:
            image = [UIImage imageNamed:@"no_ads_my_icon"];
            text = NSLocalizedString(@"Your ads will be displayed here", nil);
            break;
        case SLEmptyScreenTypeNoInternet:
            image = [UIImage imageNamed:@"reload_icon"];
            text = NSLocalizedString(@"No internet connection. Tap to reload", nil);
        default:
            break;
    }
    self.imageView.image = image;
    self.textLabel.text = text;
}

#pragma mark - Actions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.customView.screenType == SLEmptyScreenTypeNoInternet) {
        [self.customView.delegate imageViewTapped];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return CGRectContainsPoint(self.customView.containerView.frame, point);
}


@end
