//
//  SLParentCollectionViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLParentCollectionViewController.h"
#import "SLCollectionViewConstants.h"
#import "SLAPIRequest+SLAdvert.h"
#import "SLAdvert.h"
#import "UIColor+SLExtensions.h"

@interface SLParentCollectionViewController()<SLEmptyScreenViewDelegate>
@end

@implementation SLParentCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor speedleLightGrayColor];
    [self loadEmptyScreen];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([SLGridCollectionViewCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:SLGridCollectionViewCellIdentifier];
    
    [self configureRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.refreshControl beginRefreshing];
    [self loadClassifieds];
    
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)configureRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(startRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)loadEmptyScreen {
    self.emptyScreen = [[SLEmptyScreenView alloc] initWithFrame:self.view.bounds];
    self.emptyScreen.customView.screenType = [self emptyScreenType];
    self.emptyScreen.customView.delegate = self;
}

- (void)updateEmptyScreen {
    if (self.classifieds.count > 0) {
        [self.emptyScreen removeFromSuperview];
    } else {
        [self.view addSubview:self.emptyScreen];
    }
    self.emptyScreen.customView.screenType = [SLApiClient isReachable] ? [self emptyScreenType] : SLEmptyScreenTypeNoInternet;
}

- (SLEmptyScreenType)emptyScreenType {
    return SLEmptyScreenTypeHome;
}

#pragma mark - Data Loading

- (void)startRefresh:(UIRefreshControl *)refreshControl {
    self.classifieds = nil;
    [self.collectionView reloadData];
    
    [self loadClassifieds];
}

- (void)loadClassifieds {
    
}

- (void)deleteSelectedClassified {
    SLAdvert *advertisement = [self.classifieds objectAtIndex:self.selectedClassified];
    
    SLAPIRequest *deleteRequest = [SLAPIRequest deleteClassifiedWithId:advertisement.advertId];
    [deleteRequest startWithCompetionHandler:^(id response, NSError *error) {
        if (!error) {
            [SLAdvert removeAdvertisement:advertisement];
        }
        self.classifieds = nil;
        [self loadClassifieds];
    }];
}

- (SLGridCellStyle)gridCellStyleForRow:(NSInteger)row {
    return SLGridCellStyleEdit;
}

- (UIAlertController *)confirmationActionSheet {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Remove", nil)
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action) {
                                                             SLGridCollectionViewCell *cell = (SLGridCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedClassified inSection:0]];
                                                             [cell startMainActivityIndicator];
                                                             [self deleteSelectedClassified];
                                                         }];
    [alertController addAction:deleteAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:cancelAction];
    return alertController;
}

#pragma mark - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.classifieds.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLGridCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.advertisement = [self.classifieds objectAtIndex:indexPath.row];
    cell.cellStyle = [self gridCellStyleForRow:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - SLGridCollectionViewCellDelegate

- (void)gridCollectionViewCell:(SLGridCollectionViewCell *)cell leftButtonPressed:(UIButton *)sender {
    
}

- (void)gridCollectionViewCell:(SLGridCollectionViewCell *)cell rightButtonPressed:(UIButton *)sender {
    
}

#pragma mark - SLEmptyScreenViewDelegate

- (void)imageViewTapped {
    self.classifieds = nil;
    [self.emptyScreen removeFromSuperview];
    [self.refreshControl beginRefreshing];
    [self loadClassifieds];
}

@end
