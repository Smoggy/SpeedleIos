//
//  SLPreviewViewController.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/19/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLAdvert;

@interface SLPreviewBaseViewController : UIViewController
@property (nonatomic, strong) SLAdvert *advertisement;

@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

- (BOOL)showsOnlyShareButton;
- (void)configureNavigationBar;
@end
