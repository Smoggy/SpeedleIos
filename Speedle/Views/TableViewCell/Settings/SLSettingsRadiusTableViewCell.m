
//
//  SLSettingsRadiusTableViewCell.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/8/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLSettingsRadiusTableViewCell.h"
#import "SLUser.h"

@interface SLSettingsRadiusTableViewCell()
@property (assign, nonatomic) CGFloat radiusValue;

@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@end

@implementation SLSettingsRadiusTableViewCell

- (void)awakeFromNib {
    self.radiusValue = [SLUser currentUser].radiusSetting;
}

- (void)setRadiusValue:(CGFloat)radiusValue {
    _radiusValue = radiusValue;
    self.radiusSlider.value = radiusValue;
    [self updateRadiusLabel];
}

- (IBAction)radiusSliderValueChanged:(UISlider *)sender {
    self.radiusValue = sender.value;
    [[SLUser currentUser] updateUserRadiusSetting:self.radiusValue];
    [self updateRadiusLabel];
}

- (void)updateRadiusLabel {
    self.radiusLabel.text = [NSString stringWithFormat:@"%.1f km", self.radiusValue];
}

@end
