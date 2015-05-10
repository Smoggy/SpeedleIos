
//
//  SLParentTableViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/13/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLParentTableViewController.h"

@interface SLParentTableViewController ()

@end

@implementation SLParentTableViewController

static CGFloat const SLTableViewHeaderMargin = 22.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,
                                                                              CGRectGetWidth(self.tableView.bounds),
                                                                              SLTableViewHeaderMargin)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

@end
