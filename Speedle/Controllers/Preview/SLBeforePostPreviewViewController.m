//
//  SLBeforePostPreviewViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/21/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLBeforePostPreviewViewController.h"
#import "SLAPIRequest+SLAdvert.h"
#import "SLAdvert.h"
#import "SLUtilityFactory.h"

@implementation SLBeforePostPreviewViewController
@synthesize rightBarButtonItem = _rightBarButtonItem;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.photoImageVIew.image = self.advertisement.pickedImage;
    self.createdAtLabel.text = NSLocalizedString(@"now", @"now");
    
    [[[SLUtilityFactory sharedInstance] progressHUDUtility] updateHUDWithView:self.navigationController.view completionBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.adInfoTableViewController clearAllData];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (UIBarButtonItem *)rightBarButtonItem {
    if (!_rightBarButtonItem) {
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Post", nil)
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(postButtonPressed)];
        
        [_rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f]} forState:UIControlStateNormal];
    }
    return _rightBarButtonItem;
}

- (BOOL)showsOnlyShareButton {
    return NO;
}

#pragma mark - Actions

- (void)postButtonPressed {
    SLAPIRequest *createRequest = [[SLAPIRequest alloc] init];
    createRequest.progressHUDDelegate = [SLUtilityFactory sharedInstance].progressHUDUtility;
    [createRequest createAdvert:self.advertisement];
}

- (IBAction)mailButtonPressed:(id)sender {
}

- (IBAction)shareButtonPressed:(id)sender {
}

- (IBAction)phoneButtonPressed:(id)sender {
}

- (IBAction)inappropriateButtonPressed:(id)sender {
}

- (IBAction)phoneInfoButtonPressed:(id)sender {
}

- (IBAction)emailInfoButtonPressed:(id)sender {
}

@end
