//
//  SLHomeCollectionViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/17/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLHomeCollectionViewController.h"
#import "SLSearchBarCollectionReusableView.h"
#import "SLCollectionViewConstants.h"
#import "SLSegueConstants.h"
#import "SLCategoriesToSearchTableViewController.h"
#import "SLAPIRequest+SLAdvert.h"
#import "SLAPIRequest+SLUser.h"
#import "SLUtilityFactory.h"
#import "SLAdvert.h"
#import "SLUser.h"
#import "SLPreviewBaseViewController.h"
#import "SLEditInfoTableViewController.h"
#import "SLPaginationManager.h"

@interface SLHomeCollectionViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) NSString *searchQuery;
@property (strong, nonatomic) UITapGestureRecognizer *keyboardTapRecognizer;
@property (nonatomic, strong) SLPaginationManager *paginationManager;
@property (nonatomic, strong) SLUser *user;
@end

@implementation SLHomeCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.keyboardTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(triggersKeyboardRecognizer:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationBarButton];
}

#pragma mark - Initialization

- (SLEmptyScreenType)emptyScreenType {
    return SLEmptyScreenTypeHome;
}

- (SLPaginationManager *)paginationManager {
    if (!_paginationManager) {
        _paginationManager = [[SLPaginationManager alloc] init];
    }
    return _paginationManager;
}

#pragma mark - Data Loading

- (void)loadClassifieds {
    UIViewController* topMostController = self.tabBarController.navigationController.visibleViewController;
    if (![topMostController isEqual:self.tabBarController]) {
        self.classifieds = [SLAdvert allInMemoryAdverts];
        
        [self updateEmptyScreen];
        [self.refreshControl endRefreshing];
        [self.collectionView reloadData];
        return;
    }
    
    if (!self.classifieds.count) {
        [SLAdvert clearInMemoryDatabase];
        self.paginationManager = nil;
    }
    
    self.user = [SLUser currentUser];
    
    dispatch_block_t loadingBlock = ^(){
        SLAPIRequest *classifiedsRequest = [SLAPIRequest classifiedsForCurrentLocationWithQuery:self.searchQuery category:self.category skip:self.paginationManager.skipValue];
        [classifiedsRequest startWithCompetionHandler:^(NSArray *response, NSError *error) {
            if (!error) {
                [SLAdvert createOrUpdateInMemoryAdvertsWithResponse:response];
                self.classifieds = [SLAdvert allInMemoryAdverts];
                if (response.count) {
                    self.paginationManager.currentPage ++;
                }
            }
            [self updateEmptyScreen];
            [self.refreshControl endRefreshing];
            [self.collectionView reloadData];
        }];
    };
    SLLocationManagerUtility *location = [[SLUtilityFactory sharedInstance] locationUtility];
    
    if (location.currentLocation) {
        loadingBlock();
    } else {
        [location startStandardUpdatesWithDesiredAccuracy:kCLLocationAccuracyBestForNavigation
                                           distanceFilter:CLLocationDistanceMax
                                                  handler:^(CLLocation *location, NSError *error) {
                                                      [[[SLUtilityFactory sharedInstance] locationUtility] stopUpdates];
                                                      loadingBlock();
                                                  }];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SLHomeToCategoriesSegueIdentifier]) {
        SLCategoriesToSearchTableViewController *categoryController = [segue destinationViewController];
        categoryController.selectedCategory = self.category;
        categoryController.homeController = self;
    }

    if ([segue.identifier isEqualToString:SLHomeToPreviewSegueIdentifier]) {
        SLAdvert *advert = self.classifieds[self.selectedClassified];
        SLPreviewBaseViewController *previewViewController = [segue destinationViewController];
        previewViewController.advertisement = advert;
    }
    
    if ([segue.identifier isEqualToString:SLHomeToEditSegueIdentifier]) {
        SLAdvert *advert = self.classifieds[self.selectedClassified];
        SLEditInfoTableViewController *editController = [segue destinationViewController];
        editController.advertisement = advert;
        editController.initialAdvert = advert;
    }
}

- (void)configureNavigationBarButton {
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"category-button"]
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(openCategories)];
    self.tabBarController.navigationItem.rightBarButtonItem = menuBarButton;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

- (void)openCategories {
    [self performSegueWithIdentifier:SLHomeToCategoriesSegueIdentifier sender:self];
}

#pragma mark - CollectionView Delegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SLSearchBarCollectionReusableView *searchHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                         withReuseIdentifier:SLSearchBarReusableViewIdentifier
                                                                                                forIndexPath:indexPath];
    NSString *placeholderString = NSLocalizedString(@"Search", nil);
    
    if (self.category) {
        placeholderString = [placeholderString stringByAppendingFormat:@": %@", self.category.name];
    }
    
    searchHeader.searchBar.delegate = self;
    searchHeader.searchBar.placeholder = placeholderString;
    
    return searchHeader;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedClassified = indexPath.row;
    if (self.classifieds.count) {
        [self performSegueWithIdentifier:SLHomeToPreviewSegueIdentifier sender:self];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == (self.paginationManager.skipValue - 1)) {
        [self loadClassifieds];
    }
}

- (SLGridCellStyle)gridCellStyleForRow:(NSInteger)row {
    SLGridCellStyle style = SLGridCellStyleLiked;
    SLAdvert *advert = self.classifieds[row];
    if (advert) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"advertId ==[c] %@", advert.advertId];
        
        if ([advert.ownerId isEqualToString:self.user.userId]) {
            style = SLGridCellStyleEdit;
        } else if ([self.user.favourites indexOfObjectWithPredicate:predicate] == NSNotFound) {
            style = SLGridCellStyleLike;
        }
    }
    return style;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.view addGestureRecognizer:self.keyboardTapRecognizer];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.view removeGestureRecognizer:self.keyboardTapRecognizer];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchQuery = searchText;
    if (!searchText.length) {
        [self loadClassifieds];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.classifieds = nil;
    [self loadClassifieds];
}

#pragma mark - Grid Cell Delegate

- (void)gridCollectionViewCell:(SLGridCollectionViewCell *)cell leftButtonPressed:(UIButton *)sender {
    self.selectedClassified = [self.collectionView indexPathForCell:cell].row;
    [self performSegueWithIdentifier:SLHomeToEditSegueIdentifier sender:self];
}

- (void)gridCollectionViewCell:(SLGridCollectionViewCell *)cell rightButtonPressed:(UIButton *)sender {
    NSInteger adIndex = [self.collectionView indexPathForCell:cell].row;
    self.selectedClassified = adIndex;
    
    if (cell.cellStyle == SLGridCellStyleEdit) {
        [self presentViewController:[self confirmationActionSheet] animated:YES completion:nil];
    } else {
        SLAPIRequest *adToFavourites = [SLAPIRequest addToFavourites:self.classifieds[adIndex]];
        
        [adToFavourites startWithCompetionHandler:^(id response, NSError *error) {
            if (!error) {
                SLUser *user = [SLUser currentUser];
                
                if ([user addOrDeleteFavouriteAdvert:self.classifieds[adIndex]]) {
                    cell.cellStyle = SLGridCellStyleLike;
                } else {
                    cell.cellStyle = SLGridCellStyleLiked;
                }
            } else {
                cell.cellStyle = cell.cellStyle;
            }
        }];
    }
}

#pragma mark - Gesture Recognizers

- (void)triggersKeyboardRecognizer:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
