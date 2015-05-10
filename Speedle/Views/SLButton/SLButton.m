
//
//  SLButton.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/20/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLButton.h"

@implementation SLButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets titleInsets = self.titleEdgeInsets;
    CGRect titleFrame = self.titleLabel.frame;
    
    titleInsets.left = CGRectGetMidX(self.frame) - CGRectGetMidX(titleFrame) +
    CGRectGetMinX(titleFrame) - self.contentEdgeInsets.left - CGRectGetMaxX(self.imageView.frame);
    self.titleEdgeInsets = titleInsets;
}

@end
