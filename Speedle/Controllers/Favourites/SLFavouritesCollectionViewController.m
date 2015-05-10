//
//  SLFavouritesCollectionViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/23/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLFavouritesCollectionViewController.h"
#import "SLUser.h"
#import "SLAPIRequest+SLUser.h"
#import "SLSegueConstants.h"
#import "SLPreviewBaseViewController.h"

@interface SLFavouritesCollectionViewController ()

@end

@implementation SLFavouritesCollectionViewController

- (SLEmptyScreenType)emptyScreenType {
    return SLEmptyScreenTypeFavourites;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SLFavouritesToPreviewSegueIdentifier]) {
        SLPreviewBaseViewController *previewController = [segue destinationViewController];
        previewController.advertisement = self.classifieds[self.selectedClassified];
    }
}

- (void)loadClassifieds {
    [[SLAPIRequest getCurrentUserInfo] startWithCompetionHandler:^(id response, NSError *error) {
        if (!error) {
            self.classifieds = [[SLUser currentUser].favourites sortedResultsUsingProperty:@"advertName"
                                                                                 ascending:YES];
        }
        [self updateEmptyScreen];
        [self.collectionView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)deleteSelectedClassified {
    SLAdvert *advert = self.classifieds[self.selectedClassified];
    SLAPIRequest *adToFavourites = [SLAPIRequest addToFavourites:advert];
    
    [adToFavourites startWithCompetionHandler:^(id response, NSError *error) {
        if (!error){
            SLUser *user = [SLUser currentUser];
            [user addOrDeleteFavouriteAdvert:self.classifieds[self.selectedClassified]];
            [self loadClassifieds];
        }
    }];

}

#pragma mark - ColletionView DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedClassified = indexPath.row;
    [self performSegueWithIdentifier:SLFavouritesToPreviewSegueIdentifier sender:self];
}

- (SLGridCellStyle)gridCellStyleForRow:(NSInteger)row {
    return SLGridCellStyleFavourite;
}

#pragma mark - SLGridCollectionViewCellDelegate

- (void)gridCollectionViewCell:(SLGridCollectionViewCell *)cell rightButtonPressed:(UIButton *)sender {
    self.selectedClassified = [self.collectionView indexPathForCell:cell].row;
    [self presentViewController:[self confirmationActionSheet] animated:YES completion:nil];
}

@end
