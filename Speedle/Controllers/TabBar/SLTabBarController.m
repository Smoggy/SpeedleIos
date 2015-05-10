//
//  SLNavigationController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/9/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLTabBarController.h"

@implementation SLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.130 green:0.421 blue:0.673 alpha:1.000]];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"speedle-logo"]];
}

@end
