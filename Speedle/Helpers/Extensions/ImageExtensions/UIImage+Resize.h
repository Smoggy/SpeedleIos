//
//  UIImage+Resize.m
//  TooNight
//
//  Created by Gerasymenko Yevgen on 29.04.14.
//  Copyright (c) 2014 Gerasymenko Yevgen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage(ResizeCategory)
- (UIImage *)tn_resizeInRect:(NSInteger)rect;
- (UIImage *)tn_resizeInWidth:(NSInteger)width height:(NSInteger)height;
- (UIImage *)tn_rectForImageView:(UIImageView *)imageView;
- (UIImage *)tn_specialRect:(UIImageView *)imageView;
- (UIImage *)tn_resizedImage:(UIImage *)inImage toRect:(CGRect)thumbRect;
@end
