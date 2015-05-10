//
//  SLGridCollectionViewCell.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLGridCollectionViewCell.h"
#import "SLPriceFormatter.h"
#import "SLAdvert.h"
#import "UIImageView+SLWebCache.h"
#import "UIColor+SLExtensions.h"

@interface SLGridCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *currencyValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mainActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *favouriteActivityIndicator;

@end

@implementation SLGridCollectionViewCell

- (void)setAdvertisement:(SLAdvert *)advertisement {
    _advertisement = advertisement;
    [self updatePriceTitle];
    [self updateImageView];
}

- (void)updatePriceTitle {
    SLPriceFormatter *priceFormatter = [[SLPriceFormatter alloc] init];
    NSString *price = [NSString stringWithFormat:@"%.2f", _advertisement.price];
    NSString *currency = _advertisement.currency ? [self currencySymbolForCurrentAd] : @"";
    if (currency.length > 1) {
        currency = [currency stringByAppendingString:@" "];
    }
    NSString *adTitle = [NSString stringWithFormat:@"%@%@", currency, [NSString stringWithFormat:@"%@", price]];
    NSMutableAttributedString *priceAttributedString = [[NSMutableAttributedString alloc]
                                                        initWithAttributedString:[priceFormatter formatText:adTitle isBackspacePressed:NO]];
    [priceAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor speedleDarkBlueColor] range:NSMakeRange(0, adTitle.length)];
    self.currencyValueLabel.attributedText = priceAttributedString;
}

- (NSString *)currencySymbolForCurrentAd {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:_advertisement.currency];
    NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:_advertisement.currency]];
    
    return currencySymbol;
}

- (void)updateImageView {
    SLImage *image = [_advertisement.thumbnailsList firstObject];
    UIImage *placeholder = [UIImage imageNamed:@"placeholder-icon"];
    if (image) {
        [self.imageView loadImageWithURL:image.URLString placeholderImage:placeholder];
    } else {
        self.imageView.image = placeholder;
    }
}

- (void)setCellStyle:(SLGridCellStyle)cellStyle {
    _cellStyle = cellStyle;
    [self.favouriteActivityIndicator stopAnimating];
    [self.mainActivityIndicator stopAnimating];
    
    self.leftButton.hidden = cellStyle != SLGridCellStyleEdit;
    
    if (cellStyle == SLGridCellStyleLike) {
        [self.rightButton setImage:[UIImage imageNamed:@"add_to_favorite-icon-small"] forState:UIControlStateNormal];
    } else if(cellStyle == SLGridCellStyleLiked) {
        [self.rightButton setImage:[UIImage imageNamed:@"favorite-icon-small"] forState:UIControlStateNormal];
    } else if (cellStyle == SLGridCellStyleEdit) {
        [self.rightButton setImage:[UIImage imageNamed:@"delet-icon"] forState:UIControlStateNormal];
    }
}

#pragma mark - Actions

- (IBAction)rightButtonPressed:(id)sender {
    if (self.cellStyle == SLGridCellStyleLike || self.cellStyle == SLGridCellStyleLiked) {
        [self.rightButton setImage:nil forState:UIControlStateNormal];
        [self.favouriteActivityIndicator startAnimating];
    }
    
    [self.delegate gridCollectionViewCell:self rightButtonPressed:sender];
}

- (IBAction)leftButtonPressed:(id)sender {
    [self.delegate gridCollectionViewCell:self leftButtonPressed:sender];
}

- (void)startMainActivityIndicator {
    [self.mainActivityIndicator startAnimating];
}

@end
