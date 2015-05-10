//
//  SLShowAdvertViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/21/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLShowAdvertViewController.h"
#import "SLAdvert.h"
#import "SLUser.h"
#import "SLAPIRequest+SLUser.h"
#import "SLSegueConstants.h"
#import "SLEditInfoTableViewController.h"

@interface SLShowAdvertViewController ()

@end

@implementation SLShowAdvertViewController
@synthesize rightBarButtonItem = _rightBarButtonItem;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SLShowAdvertToPreviewSegueIdentifier]) {
        SLEditInfoTableViewController *editController = [segue destinationViewController];
        editController.advertisement = self.advertisement;
        editController.initialAdvert = self.advertisement;
        editController.previewController = self;
    }
}

- (UIBarButtonItem *)rightBarButtonItem {
    if (!_rightBarButtonItem) {
        _rightBarButtonItem = [self showsOnlyShareButton] ? [self editAdvertButton] : [self addToFavouritesButton];
    }
    return _rightBarButtonItem;
}

- (UIBarButtonItem *)addToFavouritesButton {
    UIImage *image = [UIImage imageNamed:[self isFavourite] ? @"favorite-icon-small" : @"add_to_favorite-icon-small"];
    return [[UIBarButtonItem alloc] initWithImage:image
                                            style:UIBarButtonItemStyleDone
                                           target:self
                                           action:@selector(addToFavouritesButtonPressed:)];
}

- (UIBarButtonItem *)editAdvertButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                         target:self
                                                         action:@selector(editAdvertButtonPressed:)];
}

- (BOOL)showsOnlyShareButton {
    return [self.advertisement.ownerId isEqualToString:[SLUser currentUser].userId];
}

- (BOOL)isFavourite {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"advertId ==[c] %@", self.advertisement.advertId];
    return [[SLUser currentUser].favourites indexOfObjectWithPredicate:predicate] != NSNotFound;
}

- (void)configureNavigationBar {
    self.rightBarButtonItem = nil;
    [super configureNavigationBar];
}

#pragma mark - Actions

- (void)addToFavouritesButtonPressed:(UIBarButtonItem *)sender {
    SLAPIRequest *adToFavourites = [SLAPIRequest addToFavourites:self.advertisement];
    
    [adToFavourites startWithCompetionHandler:^(id response, NSError *error) {
        if (!error){
            SLUser *user = [SLUser currentUser];
            [user addOrDeleteFavouriteAdvert:self.advertisement];
            [self configureNavigationBar];
        }
    }];
}

- (void)editAdvertButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:SLShowAdvertToPreviewSegueIdentifier sender:self];
}

@end
