//
//  SLNewAdTableViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/9/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAdInfoTableViewController.h"

#import "SLAdBaseInfoTableViewCell.h"
#import "SLAdTitleInfoTableViewCell.h"
#import "SLCategoryInfoTableViewCell.h"

#import "SLAdCategoriesTableViewController.h"
#import "SLNewAdConstants.h"
#import "SLSegueConstants.h"
#import "SLFontConstants.h"
#import "SLAdvert.h"
#import "SLUser.h"

#import <PECropViewController.h>
#import "UIColor+SLExtensions.h"

#import "SLAPIRequest+SLAdvert.h"
#import "SLBeforePostPreviewViewController.h"

#import <RLMObject+Copying.h>
#import "SLUtilityFactory.h"


typedef NS_ENUM(NSInteger, SLAdTableViewCell) {
    SLAdTableViewCellBaseInfo,
    SLAdTableViewCellCategory,
    SLAdTableViewCellTitle,
    SLAdTableViewCellDescription
};

@interface SLAdInfoTableViewController ()<SLAdBaseInfoTableViewCellDelegate,
                                            PECropViewControllerDelegate,
                                            SLAdDescriptionTableViewCellDelegate,
                                            UIImagePickerControllerDelegate,
                                            UINavigationControllerDelegate,
                                            UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray *cellsHeights;
@property (nonatomic, assign) BOOL isBaseInfoCellExpanded;

@property (nonatomic, strong) UIBarButtonItem *postBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *cancelBarButtonItem;
@end

@implementation SLAdInfoTableViewController
@synthesize advertisement = _advertisement;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNibs];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[SLUtilityFactory sharedInstance] progressHUDUtility] updateHUDWithView:self.navigationController.view completionBlock:^{
        [self clearAllData];
    }];
    
    [self configureNavigationBarButtons];
    [self.tableView reloadData];
}

- (void)registerNibs {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([SLAdBaseInfoTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:SLAdBaseInfoTableViewCellIdentifier];
    
    nib = [UINib nibWithNibName:NSStringFromClass([SLCategoryInfoTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:SLCategoryInfoTableViewCellIdentifier];
    
    nib = [UINib nibWithNibName:NSStringFromClass([SLAdTitleInfoTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:SLAdTitleInfoTableViewCellIdentifier];
    
    nib = [UINib nibWithNibName:NSStringFromClass([SLAdDescriptionTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:SLAdDescriptionInfoTableViewCellIdentifier];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:[self categoriesSegueIdentifier]]) {
        SLAdCategoriesTableViewController *categoriesViewController = segue.destinationViewController;
        categoriesViewController.advertisement = self.advertisement;
    }
    
    if ([segue.identifier isEqualToString:SLNewAdToPreviewSegueIdentifier]) {
        SLBeforePostPreviewViewController *viewController = [segue destinationViewController];
        viewController.advertisement = self.advertisement;
        viewController.adInfoTableViewController = self;
    }
}

- (void)configureNavigationBarButtons {
    self.cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                             target:self
                                                                             action:@selector(cancelButtonPressed:)];
    self.postBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Post", nil)
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(postButtonPressed:)];
    [self.postBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f]} forState:UIControlStateNormal];
    self.tabBarController.navigationItem.leftBarButtonItem = self.cancelBarButtonItem;
    self.tabBarController.navigationItem.rightBarButtonItem = self.postBarButtonItem;
}

#pragma mark - Instantiations

- (void)setAdvertisement:(SLAdvert *)advertisement {
    if (!_advertisement) {
        advertisement = [advertisement shallowCopy];
    }
    _advertisement = advertisement;
}

- (SLAdvert *)advertisement {
    if (!_advertisement) {
        SLUser *currentUser = [SLUser currentUser];
        _advertisement = [[SLAdvert alloc] init];
        _advertisement.ownerName = currentUser.username;
        _advertisement.email = currentUser.email;
        _advertisement.phoneNumber = currentUser.phoneNumber.length ? currentUser.phoneNumber : nil;
        NSLocale *currentLocale = [NSLocale currentLocale];
        _advertisement.currency = [currentLocale objectForKey:NSLocaleCurrencyCode];
    }
    return _advertisement;
}

- (NSMutableArray *)cellsHeights {
    if (!_cellsHeights) {
        _cellsHeights = [NSMutableArray arrayWithArray:@[
                                                         @(SLAdBaseInfoTableViewCellDefaultHeight),
                                                         @(SLCategoryInfoTableViewCellHeight),
                                                         @(SLAdTitleInfoTableViewCellHeight),
                                                         @(SLAdDescriptionInfoTableViewCellHeight)
                                                         ]];
    }
    return _cellsHeights;
}

- (void)clearAllData {
    self.advertisement = nil;
    [self.tableView reloadData];
}

- (NSString *)categoriesSegueIdentifier {
    return SLAdToCategoriesSegueIdentifier;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SLNewAddSectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case SLAdTableViewCellBaseInfo:
            cell = [self configureBaseInfoCell];
            break;
        case SLAdTableViewCellCategory:
            cell = [self configureCategoryCell];
            break;
        case SLAdTableViewCellTitle:
            cell = [self configureTitleCell];
            break;
        case SLAdTableViewCellDescription:
            cell = [self configureDescriptionCell];
            break;
        default:
            break;
    }
    NSAssert(cell, @"Wrong number of cells.");
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellsHeights[indexPath.section] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:[self categoriesSegueIdentifier] sender:self];
}

#pragma mark - Cells Configuring

- (SLAdBaseInfoTableViewCell *)configureBaseInfoCell {
    SLAdBaseInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SLAdBaseInfoTableViewCellIdentifier];
    cell.delegate = self;
    cell.isExpanded = self.isBaseInfoCellExpanded;
    cell.advertisement = self.advertisement;
    
    return cell;
}

- (SLCategoryInfoTableViewCell *)configureCategoryCell {
    SLCategoryInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SLCategoryInfoTableViewCellIdentifier];
    NSString *categoriesCellTitle = NSLocalizedString(@"Select Categories", nil);
    NSArray *categories = self.advertisement.categories;
    
    if (categories.count) {
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        for (SLCategory *category in categories) {
            [titles addObject:category.name];
        }
        categoriesCellTitle = [titles componentsJoinedByString:@", "];
    }
    
    cell.textLabel.text = categoriesCellTitle;
    return cell;
}

- (SLAdTitleInfoTableViewCell *)configureTitleCell {
    SLAdTitleInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SLAdTitleInfoTableViewCellIdentifier];
    cell.advertisement = self.advertisement;
    return cell;
}

- (SLAdDescriptionTableViewCell *)configureDescriptionCell {
    SLAdDescriptionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SLAdDescriptionInfoTableViewCellIdentifier];
    cell.advertisement = self.advertisement;
    cell.delegate = self;
    cell.buttonStyle = [self bottomButtonStyle];
    return cell;
}

- (SLAdDescriptionCellButtonStyle)bottomButtonStyle {
    return SLAdDescriptionCellButtonStylePreview;
}

#pragma mark - SLAdBaseInfoTableViewCellDelegate

- (void)tableViewCell:(SLAdBaseInfoTableViewCell *)cell advertisementImageViewTapped:(UIImageView *)imageView {
    [self presentViewController:[self selectPhotoActionSheet]  animated:YES completion:nil];
}

- (void)updateTableViewCellFrame:(SLAdBaseInfoTableViewCell *)cell {
    self.isBaseInfoCellExpanded = cell.isExpanded;
    self.cellsHeights[SLAdTableViewCellBaseInfo] = cell.isExpanded ?
    @(SLAdBaseInfoTableViewCellExpandedHeight) :
    @(SLAdBaseInfoTableViewCellDefaultHeight);
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SLAdTableViewCellBaseInfo]
                  withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Image Picking

- (UIAlertController *)selectPhotoActionSheet {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose Ad Picture", nil)
                                               message:nil
                                        preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Take Photo", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [self openImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Choose from Library", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [self openImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                      }]];
    return alertController;
}

- (void)openImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *pickedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    CGFloat width = pickedImage.size.width;
    CGFloat height = pickedImage.size.height;
    CGFloat length = MIN(width, height);
    CGRect imageCropRect = CGRectMake((width - length) / 2, (height - length) / 2, length, length);
    
    
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = pickedImage;
    controller.keepingCropAspectRatio = YES;
    controller.cropAspectRatio = 1.0f;
    controller.cropRect = imageCropRect;
    controller.toolbarHidden = YES;
    controller.rotationEnabled = NO;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [picker dismissViewControllerAnimated:NO completion:NULL];
    [self presentCropViewController:navigationController];
}

- (void)presentCropViewController:(UINavigationController *)cropViewController {
    if (self.presentedViewController) {
        [self performSelector:@selector(presentCropViewController:)
                   withObject:cropViewController
                   afterDelay:0.1f];
        return;
    }
    [self presentViewController:cropViewController animated:NO completion:NULL];
}

- (id)cellForType:(SLAdTableViewCell)cellType {
    return [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:cellType]];
}

#pragma mark - Actions

- (BOOL)isEnteredDataValid {
    [self.view endEditing:YES];
    
    SLAdBaseInfoTableViewCell *baseInfoCell = [self cellForType:SLAdTableViewCellBaseInfo];
    SLAdTitleInfoTableViewCell *titleInfoCell = [self cellForType:SLAdTableViewCellTitle];
    SLAdDescriptionTableViewCell *descriptionCell = [self cellForType:SLAdTableViewCellDescription];
    
    BOOL isEnteredDataValid = [baseInfoCell isEnteredDataValid];
    isEnteredDataValid &= [titleInfoCell isEnteredDataValid];
    isEnteredDataValid &= [descriptionCell isEnteredDataValid];
    
    return isEnteredDataValid;
}

- (void)postButtonPressed:(id)sender {
    if ([self isEnteredDataValid]) {
        SLAPIRequest *createRequest = [[SLAPIRequest alloc] init];
        createRequest.progressHUDDelegate = [SLUtilityFactory sharedInstance].progressHUDUtility;
        [createRequest createAdvert:self.advertisement];
    }
}


- (void)cancelButtonPressed:(id)sender {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure?", nil)
                                message:NSLocalizedString(@"The ad will not be saved", nil)
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"NO", nil)
                      otherButtonTitles:NSLocalizedString(@"YES", nil), nil] show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex != buttonIndex) {
        [self clearAllData];
    }
}

#pragma mark - PECropViewControllerDelegate

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    self.advertisement.pickedImage = croppedImage;
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - SLAdDescriptionTableViewCellDelegate

- (void)tableViewCell:(SLAdDescriptionTableViewCell *)cell previewButtonTapped:(UIButton *)button {
    if ([self isEnteredDataValid]) {
        [self performSegueWithIdentifier:SLNewAdToPreviewSegueIdentifier sender:self];
    }
}

@end
