//
//  UIImageView+SLWebCache.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/17/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface UIImageView (SLWebCache)
- (void)loadImageWithURL:(NSString *)URLSting;
- (void)loadImageWithURL:(NSString *)URLSting completionHandler:(SDWebImageCompletionBlock)completionBlock;
- (void)loadImageWithURL:(NSString *)URLSting placeholderImage:(UIImage *)placeholder;
@end
