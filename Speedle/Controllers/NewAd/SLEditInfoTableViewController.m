//
//  SLEditInfoTableTableViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/21/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLEditInfoTableViewController.h"
#import "SLSegueConstants.h"
#import "SLAPIRequest+SLAdvert.h"
#import "SLAdvert.h"
#import "SLPreviewBaseViewController.h"
#import "SLUtilityFactory.h"

#import "UIViewController+SLBackButtonHandler.h"

@implementation SLEditInfoTableViewController

- (BOOL)navigationShouldPopOnBackButton {
    [self.view endEditing:YES];
    
    BOOL shouldPop = [[self.advertisement JSONDictionary] isEqualToDictionary:[self.initialAdvert JSONDictionary]];
    
    if (!shouldPop) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Are you sure?", nil)
                                                                                 message:NSLocalizedString(@"The ad will not be saved", nil)
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"YES", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             [self clearAllData];
                                                         }]];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"NO", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    return shouldPop;
}

- (NSString *)categoriesSegueIdentifier {
    return SLEditToCategoriesSegueIdentifier;
}

- (SLAdDescriptionCellButtonStyle)bottomButtonStyle {
    return SLAdDescriptionCellButtonStyleRemove;
}

- (void)configureNavigationBarButtons {
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil)
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(saveButtonPressed)];
    
    [saveButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)saveButtonPressed {
    if ([self isEnteredDataValid]) {
        SLAPIRequest *updateRequest = [[SLAPIRequest alloc] init];
        updateRequest.progressHUDDelegate = [SLUtilityFactory sharedInstance].progressHUDUtility;
        [updateRequest updateAdvert:self.advertisement];
    }
}

- (void)deleteClassified {
    SLAPIRequest *deleteRequest = [SLAPIRequest deleteClassifiedWithId:self.advertisement.advertId];
    [deleteRequest startWithCompetionHandler:^(id response, NSError *error) {
        if (!error) {
            [SLAdvert removeAdvertisement:self.advertisement];
            [self clearAllData];
        }
    }];
}

- (void)clearAllData {
    if (self.previewController) {
        self.previewController.advertisement = self.advertisement;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SLAdDescriptionTableViewCellDelegate

- (void)tableViewCell:(SLAdDescriptionTableViewCell *)cell previewButtonTapped:(UIButton *)button {
    [self presentViewController:[self confirmationActionSheet] animated:YES completion:nil];
}

- (UIAlertController *)confirmationActionSheet {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Remove", nil)
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action) {
                                                             [self deleteClassified];
                                                         }];
    [alertController addAction:deleteAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:cancelAction];
    return alertController;
}


@end
