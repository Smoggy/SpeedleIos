//
//  SLSettingsTableViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/8/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLSettingsTableViewController.h"
#import "SLUtilityFactory.h"

typedef NS_ENUM(NSInteger, SLSettingsTableViewCell) {
    SLSettingsTableViewCellPersonalSettings,
//    SLSettingsTableViewCellAbout,
    SLSettingsTableViewCellRadius,
    SLSettingsTableViewCellPrivacyPolicy,
    SLSettingsTableViewCellLogOut
};

@interface SLSettingsTableViewController()

@end

@implementation SLSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == SLSettingsTableViewCellLogOut) {
        UIAlertController *logOutConfirmationSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Are you sure you want to Log Out?", nil)
                                                                                         message:nil
                                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
        [logOutConfirmationSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:nil]];
        [logOutConfirmationSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Log Out", nil)
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction *action) {
                                                                      [[[SLUtilityFactory sharedInstance] sessionUtility] logOut];
                                                                  }]];
        [self presentViewController:logOutConfirmationSheet animated:YES completion:nil];
    }
}

@end
