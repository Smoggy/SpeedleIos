//
//  SLPreviewViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/19/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLPreviewBaseViewController.h"
#import "SLAdvert.h"
#import "NSDate+SLRelativeDate.h"
#import "SLPriceFormatter.h"
#import "SLAPIRequest+SLAdvert.h"
#import "SLUtilityFactory.h"
#import <MessageUI/MessageUI.h>
#import "UIImageView+SLWebCache.h"

#import <AQSFacebookActivity.h>
#import <AQSTwitterActivity.h>
#import <GPPShareActivity.h>

@interface SLPreviewBaseViewController ()<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *phoneInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *emailInfoButton;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mailButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inappropriateButtonWidth;

@end

@implementation SLPreviewBaseViewController

- (NSString *)nibName {
    return @"SLPreviewBaseViewController";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateAdvertisementInfo];
    [self configureNavigationBar];
}

- (BOOL)showsOnlyShareButton {
    return NO;
}

#pragma mark - Data Loading

- (void)updateAdvertisementInfo {
    if (self.advertisement) {
        [self updateCategories];
        [self updatePriceLabel];
        [self loadImageView];
        
        if (![[UIDevice currentDevice].model hasPrefix:@"iPhone"]) {
            self.phoneButtonWidth.constant = 0;
        }
        
        if (!self.advertisement.phoneNumber.length) {
            self.phoneButtonWidth.constant = 0;
            self.phoneInfoButton.hidden = YES;
        }
        [self.phoneInfoButton setTitle:self.advertisement.phoneNumber forState:UIControlStateNormal];
        
        if (!self.advertisement.email.length) {
            self.emailInfoButton.hidden = YES;
            self.mailButtonWidth.constant = 0;
        }
        [self.emailInfoButton setTitle:self.advertisement.email forState:UIControlStateNormal];
        
        self.titleLabel.text = self.advertisement.advertName;
        self.descriptionTextView.text = self.advertisement.advertDescription;
        self.createdAtLabel.text = [self.advertisement.created distanceOfTimeInWordsToNow];
        self.firstNameLabel.text = self.advertisement.ownerName;
        
        if ([self showsOnlyShareButton]) {
            self.mailButtonWidth.constant = 0;
            self.phoneButtonWidth.constant = 0;
            self.inappropriateButtonWidth.constant = 0;
            
            self.phoneInfoButton.userInteractionEnabled = NO;
            self.emailInfoButton.userInteractionEnabled = NO;
        }
    }
}

- (void)loadImageView {
    SLImage *image = [self.advertisement.imagesList firstObject];
    [self.photoImageVIew loadImageWithURL:image.URLString completionHandler:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.reloadButton.hidden = (error == nil);
    }];
}

- (void)updateCategories {
    
    if (!self.advertisement.categoriesIds.count) {
        self.categoriesLabel.hidden = YES;
        self.categoryLabelWidth.constant = 0.0f;
    }
    
    NSArray *categories = self.advertisement.categories;
    
    if (categories.count) {
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        for (SLCategory *category in categories) {
            [titles addObject:category.name];
        }
        self.categoriesLabel.text = [titles componentsJoinedByString:@", "];
    }
}

- (void)updatePriceLabel {
    SLPriceFormatter *priceFormatter = [[SLPriceFormatter alloc] init];
    NSString *price = [NSString stringWithFormat:@"%.2f", _advertisement.price];
    NSString *currency = _advertisement.currency ? [self currencySymbolForCurrentAd] : @"";
    if (currency.length > 1) {
        currency = [currency stringByAppendingString:@" "];
    }
    NSString *adTitle = [NSString stringWithFormat:@"%@%@", currency, [NSString stringWithFormat:@"%@", price]];
    NSMutableAttributedString *priceAttributedString = [[NSMutableAttributedString alloc]
                                                        initWithAttributedString:[priceFormatter formatText:adTitle isBackspacePressed:NO]];
    [priceAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, adTitle.length)];
    self.priceLabel.attributedText = priceAttributedString;
}

- (NSString *)currencySymbolForCurrentAd {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:_advertisement.currency];
    NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:_advertisement.currency]];
    
    return currencySymbol;
}

#pragma mark - Navigation Bar Configuration

- (void)configureNavigationBar {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"speedle-logo"]];
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
}

#pragma mark - Actions

- (IBAction)mailButtonPressed:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        composeViewController.mailComposeDelegate = self;
        [composeViewController setToRecipients:@[self.advertisement.email]];
        [composeViewController setSubject:self.advertisement.advertName];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", self.advertisement.email]]];
    }
}

- (IBAction)shareButtonPressed:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.speedle.se/classifieds/%@", self.advertisement.advertId]];
    NSArray* activityItems = @[self.advertisement.advertName, url];
    
    GPPShareActivity *gppShareActivity = [[GPPShareActivity alloc] init];
    gppShareActivity.canShowEmptyForm = YES;
    
    AQSFacebookActivity *facebookActivity = [[AQSFacebookActivity alloc] init];
    AQSTwitterActivity *twitterActivity = [[AQSTwitterActivity alloc] init];
    
    NSArray *activities = @[gppShareActivity, facebookActivity, twitterActivity];
    
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:activities];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypePostToTwitter];
    activityViewController.popoverPresentationController.barButtonItem = sender;
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (IBAction)phoneButtonPressed:(id)sender {
    NSString *phoneNumber = [[self.advertisement.phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                             componentsJoinedByString:@""];
    NSString *phoneURLString = [@"telprompt://" stringByAppendingString:phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
}

- (IBAction)inappropriateButtonPressed:(id)sender {
    [self presentViewController:[self inappropriateAlertController] animated:YES completion:nil];
}

- (IBAction)phoneInfoButtonPressed:(id)sender {
    UIAlertController *controller = [self alertControllerForTitle:self.advertisement.phoneNumber];
    if ([[UIDevice currentDevice].model hasPrefix:@"iPhone"]) {
        [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Call", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         [self phoneButtonPressed:nil];
                                                     }]];
    }
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)emailInfoButtonPressed:(id)sender {
    UIAlertController *controller = [self alertControllerForTitle:self.advertisement.email];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Send Email", nil)
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action) {
                                                     [self mailButtonPressed:nil];
                                                 }]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)copyStringToClipboard:(NSString *)string {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Success", @"Success")
                                                                        message:NSLocalizedString(@"Link copied to clipboard", @"Link copied to clipboard")
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:controller animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [controller dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (void)markIsInappropriate {
    SLAPIRequest *abuseRequest = [SLAPIRequest postAnAbuse:self.advertisement];
    [abuseRequest start];
}

- (IBAction)reloadButtonPressed:(id)sender {
    self.reloadButton.hidden = YES;
    [self loadImageView];
}


#pragma mark - AlertController Methods

- (UIAlertController *)alertControllerForTitle:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Copy", nil)
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action) {
                                                     [self copyStringToClipboard:title];
                                                 }]];

    return alertController;
}

- (UIAlertController *)inappropriateAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Mark Inappropriate", nil)
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction *action) {
                                                          [self presentViewController:[self confirmationAlertController] animated:YES completion:nil];
                                                      }]];
    return alertController;
}

- (UIAlertController *)confirmationAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Mark this ad inappropriate?", nil)
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", nil)
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction *action) {
                                                          [self markIsInappropriate];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    return alertController;
}

- (UIAlertController *)shareAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Share this advertisement", nil)
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Facebook", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [[[SLUtilityFactory sharedInstance] facebookUtility] shareAdvertisement:self.advertisement];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Twitter", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Google+", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    return alertController;
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
