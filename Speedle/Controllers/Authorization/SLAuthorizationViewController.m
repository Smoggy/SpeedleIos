//
//  SLAuthorizationViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/5/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAuthorizationViewController.h"
#import "SLUtilityFactory.h"
#import "SLSegueConstants.h"
#import "SLButton.h"
#import "SLConfirmationViewController.h"

@interface SLAuthorizationViewController()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSDictionary<FBGraphUser> *facebookUser;
@property (weak, nonatomic) IBOutlet SLButton *facebookButton;
@end

@implementation SLAuthorizationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)signInWithFacebookButtonPressed:(UIButton *)sender {
    [self.activityIndicator startAnimating];
    self.facebookButton.enabled = NO;
    SLFacebookUtility *facebookUtility = [[SLUtilityFactory sharedInstance] facebookUtility];
    [facebookUtility openSessionWithHandler:^(NSString *token, NSError *error) {
        if (token) {
            [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
                [self.activityIndicator stopAnimating];
                self.facebookButton.enabled = YES;
                if (!error) {
                    self.facebookUser = FBuser;
                    [self showConfirmationViewController];
                } else {
                    NSLog(@"Error updating user: %@", error);
                }
            }];
        } else {
            [self.activityIndicator stopAnimating];
            self.facebookButton.enabled = YES;
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sign In Failed", nil)
                                       message:NSLocalizedString(@"Please try again later", nil)
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            [facebookUtility closeSession];
        }
        
    }];
}

- (void)showConfirmationViewController {
    [self performSegueWithIdentifier:SLAuthorizationToConfirmationSegueIdentifier sender:self];
}

- (void)showTabbarViewController {
    [self performSegueWithIdentifier:SLAuthorizationToTabbarSegueIdentifier sender:self];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SLAuthorizationToConfirmationSegueIdentifier]) {
        SLConfirmationViewController *confirmationController = [segue destinationViewController];
        confirmationController.facebookUser = self.facebookUser;
        self.facebookUser = nil;
    }
}

@end
