//
//  SLConfirmationViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/20/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLConfirmationViewController.h"
#import "UIImageView+SLWebCache.h"
#import "SLProgressHUDView.h"
#import "SLSegueConstants.h"
#import "SLUtilityFactory.h"

#import "SLAPIRequest+SLAuthorization.h"
#import "SLAPIRequest+SLUser.h"
#import "SLAPIRequest+SLCategory.h"

#import <KINWebBrowserViewController.h>
#import "SLConstants.h"
#import "UIColor+SLExtensions.h"
#import "SLFontConstants.h"

#import <MZSelectableLabel.h>

@interface SLConfirmationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet MZSelectableLabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *notYouButton;
@property (weak, nonatomic) IBOutlet MZSelectableLabel *termsLabel;

@end

@implementation SLConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSelectableLabel];
    [self setupNotYouButton];
    
    if (self.facebookUser) {
         NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", [self.facebookUser objectID]];
        self.userPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.userPhotoImageView loadImageWithURL:userImageURL];
        self.usernameLabel.text = [NSString stringWithFormat:@"%@ %@", [self.facebookUser first_name], [self.facebookUser last_name]];
    }
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"speedle-logo"]];
}

- (void)setupSelectableLabel {
    
    NSMutableAttributedString *selectableString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"By tapping to continue, you indicating that you have read the Privacy Policy and agree to the Terms of Service", nil)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [selectableString addAttribute:NSForegroundColorAttributeName value:[UIColor speedleDarkGrayColor] range:NSMakeRange(0, selectableString.length)];
    [selectableString addAttribute:NSFontAttributeName value:[UIFont fontWithName:SLHelveticaNeueLightFontName size:15.0] range:NSMakeRange(0, selectableString.length)];
    [selectableString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, selectableString.length)];
    
    NSRange termsRange = [selectableString.string rangeOfString:NSLocalizedString(@"Privacy Policy", nil)];
    NSRange privacyRange = [selectableString.string rangeOfString:NSLocalizedString(@"Terms of Service", nil)];
    
    [selectableString addAttribute:NSFontAttributeName value:[UIFont fontWithName:SLHelveticaNeueMediumFontName size:15.0f] range:termsRange];
    [selectableString addAttribute:NSFontAttributeName value:[UIFont fontWithName:SLHelveticaNeueMediumFontName size:15.0f] range:privacyRange];
    self.termsLabel.attributedText = selectableString;
    
    [self.termsLabel setSelectableRange:termsRange hightlightedBackgroundColor:[UIColor speedleHighlightLightGrayColor]];
    [self.termsLabel setSelectableRange:privacyRange hightlightedBackgroundColor:[UIColor speedleHighlightLightGrayColor]];
    
    [self.termsLabel setSelectionHandler:^(NSRange range, NSString *string) {
        [self stringPressed:string];
    }];
}

- (void)setupNotYouButton {
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Not You?", nil)];
    NSRange stringRange = NSMakeRange(0, titleString.string.length);
    [titleString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor lightGrayColor]
                        range:stringRange];
    [titleString addAttribute:NSUnderlineStyleAttributeName
                        value:@1
                        range:stringRange];
    [self.notYouButton setAttributedTitle:titleString forState:UIControlStateNormal];
}

- (IBAction)continueButtonPressed:(id)sender {
    SLAPIRequest *authRequest = [SLAPIRequest renewAccessTokenUsingFacebookToken];
    
    NSURLSessionTask *urlTask = [authRequest startWithCompetionHandler:^(id response, NSError *error) {
        [SLApiClient sharedClient].accessToken = response[SLAPIIngoingToken];
        if (!error) {
            [[SLAPIRequest getCurrentUserInfo] startWithCompetionHandler:^(id response, NSError *error) {
                if (!error) {
                    [self showTabbarViewController];
                }
            }];
        }
    }];
    
    [[SLProgressHUDView progressHUD] showHUDAddedToTask:urlTask];
}

#pragma mark - Actions

- (IBAction)notYouButtonPressed:(id)sender {
    [[[SLUtilityFactory sharedInstance] facebookUtility] closeSession];
    [self backButtonPressed:nil];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showTabbarViewController {
    [self performSegueWithIdentifier:SLConfirmationToTabbarSegueIdentifier sender:self];
}

- (void)stringPressed:(NSString *)string {
    UINavigationController *webBrowserNavigationController = [KINWebBrowserViewController navigationControllerWithWebBrowser];
    [self presentViewController:webBrowserNavigationController animated:YES completion:nil];
    
    KINWebBrowserViewController *webBrowser = [webBrowserNavigationController rootWebBrowser];
    [webBrowser loadURLString:[string isEqualToString:NSLocalizedString(@"Privacy Policy", nil)] ? SLPrivacyPolicyURLString : SLTermsOfServiceURLString];
}

@end
