//
//  UIImageView+SLWebCache.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/17/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "UIImageView+SLWebCache.h"

@implementation UIImageView (SLWebCache)

- (void)loadImageWithURL:(NSString *)URLSting {
    [self loadImageWithURL:URLSting placeholderImage:nil];
}

- (void)loadImageWithURL:(NSString *)URLSting completionHandler:(SDWebImageCompletionBlock)completionBlock {
    if (URLSting) {
        [self setImageWithURL:[NSURL URLWithString:URLSting] completed:completionBlock usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
}

- (void)loadImageWithURL:(NSString *)URLSting placeholderImage:(UIImage *)placeholder {
    if (URLSting) {
        [self loadImageWithURL:URLSting completionHandler:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error || !image) {
                self.image = placeholder;
            }
        }];
    }
}

@end
