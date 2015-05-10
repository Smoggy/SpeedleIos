//
//  SLMyAdsColletionViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/17/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLMyAdsCollectionViewController.h"
#import "SLAdvert.h"
#import "SLAPIRequest+SLAdvert.h"
#import "SLSegueConstants.h"
#import "SLPreviewBaseViewController.h"
#import "SLEditInfoTableViewController.h"

@implementation SLMyAdsCollectionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (SLEmptyScreenType)emptyScreenType {
    return SLEmptyScreenTypeMyAds;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SLAdvert *advert = self.classifieds[self.selectedClassified];
    if ([segue.identifier isEqualToString:SLMyAdsToPreviewSegueIdentifier]) {
        SLPreviewBaseViewController *previewViewController = [segue destinationViewController];
        previewViewController.advertisement = advert;
    }
    
    if ([segue.identifier isEqualToString:SLMyAdsToEditSegueIdentifier]) {
        SLEditInfoTableViewController *editController = [segue destinationViewController];
        editController.advertisement = advert;
        editController.initialAdvert = advert;
    }
}

#pragma mark - Data Processing

- (void)loadClassifieds {
    [[SLAPIRequest currentUserClassifieds] startWithCompetionHandler:^(id response, NSError *error) {
        if (!error) {
            [SLAdvert createOrUpdateAdvertsWithResponse:response];
            self.classifieds = [SLAdvert currentUserAdverts];
        }
        [self updateEmptyScreen];
        [self.refreshControl endRefreshing];
        [self.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedClassified = indexPath.row;
    [self performSegueWithIdentifier:SLMyAdsToPreviewSegueIdentifier sender:self];
}

#pragma mark - SLGridCollectionViewCellDelegate

- (void)gridCollectionViewCell:(SLGridCollectionViewCell *)cell leftButtonPressed:(UIButton *)sender {
    self.selectedClassified = [self.collectionView indexPathForCell:cell].row;
    [self performSegueWithIdentifier:SLMyAdsToEditSegueIdentifier sender:self];
}

- (void)gridCollectionViewCell:(SLGridCollectionViewCell *)cell rightButtonPressed:(UIButton *)sender {
    self.selectedClassified = [self.collectionView indexPathForCell:cell].row;
    [self presentViewController:[self confirmationActionSheet] animated:YES completion:nil];
}

@end
