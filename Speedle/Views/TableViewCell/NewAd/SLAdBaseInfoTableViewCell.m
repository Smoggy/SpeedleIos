
//
//  SLAdBaseInfoTableViewCell.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/9/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAdBaseInfoTableViewCell.h"
#import "SLTextField.h"
#import "SLAdvert.h"

#import "UIColor+SLExtensions.h"
#import <UIView+Shake.h>

#import "SLRegexConstants.h"
#import "SLFontConstants.h"
#import "UIImageView+SLWebCache.h"

typedef NS_ENUM(NSInteger, SLTextFieldType) {
    SLTextFieldTypeUsername,
    SLTextFieldTypePhoneNumber,
    SLTextFieldTypeEmail,
    SLTextFieldTypePrice
};

@interface SLAdBaseInfoTableViewCell() <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoIconImageView;

@property (weak, nonatomic) IBOutlet SLTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet SLTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet SLTextField *emailTextField;
@property (weak, nonatomic) IBOutlet SLTextField *priceTextField;

@property (weak, nonatomic) IBOutlet UIButton *currencyButton;
@property (weak, nonatomic) IBOutlet UIPickerView *currencyPickerView;
@end

@implementation SLAdBaseInfoTableViewCell
@synthesize advertisement = _advertisement;

static NSInteger SLTouchableImageViewTag = 10;

- (void)awakeFromNib {
    NSString *currencyCode = self.advertisement.currency;
    
    if (!currencyCode) {
        NSLocale *currentLocale = [NSLocale currentLocale];
        currencyCode = [currentLocale objectForKey:NSLocaleCurrencyCode];
    }
    
    self.emailTextField.regexString = SLEmailRegularExpression;
    self.phoneTextField.regexString = SLPhoneNumberRegularExpression;
    self.firstNameTextField.regexString = SLUsernameRegularExpression;
    self.priceTextField.regexString = SLPriceRegularExpression;
    
    [self updateViewsWithCurrencyCode:currencyCode];
    self.currencyButton.layer.borderColor = [[UIColor textFieldDarkGrayColor] CGColor];
}

- (void)setAdvertisement:(SLAdvert *)advertisement {
    _advertisement = advertisement;
    
    self.firstNameTextField.text = _advertisement.ownerName;
    self.emailTextField.text = _advertisement.email;
    
    if (_advertisement.pickedImage) {
        self.photoImageView.image = _advertisement.pickedImage;
    } else {
        SLImage *image = [_advertisement.imagesList firstObject];
        if (image) {
            [self.photoImageView loadImageWithURL:image.URLString];
        } else {
            self.photoImageView.image = nil;
        }
    }
    
    if (_advertisement.price) {
        self.priceTextField.attributedText = [self.priceTextField.textFieldValidatorSupport.textFormatter
                                              formatText:[NSString stringWithFormat:@"%.2f", _advertisement.price] isBackspacePressed:NO];
    } else {
        self.priceTextField.text = nil;
    }
    
    if (_advertisement.phoneNumber) {
        self.phoneTextField.text = [self.phoneTextField.textFieldValidatorSupport.textFormatter
                                    formatText:_advertisement.phoneNumber isBackspacePressed:NO];
    } else {
        self.phoneTextField.text = nil;
    }
    
    [self updateViewsWithCurrencyCode:_advertisement.currency];
    [self updateTextFieldsMandatoryValue];
}

- (void)setIsExpanded:(BOOL)isExpanded {
    _isExpanded = isExpanded;
    self.currencyPickerView.hidden = !isExpanded;
}

- (void)updateViewsWithCurrencyCode:(NSString *)currencyCode {
    if (currencyCode) {
        NSInteger currentCurrencyIndex = [[NSLocale commonISOCurrencyCodes] indexOfObject:currencyCode];
        [self.currencyPickerView reloadAllComponents];
        [self.currencyPickerView selectRow:currentCurrencyIndex inComponent:0 animated:YES];
        [self.currencyButton setTitle:[self localeCurrencyStringForRow:currentCurrencyIndex] forState:UIControlStateNormal];
    }
}

- (IBAction)currencyButtonPressed:(UIButton *)sender {
    self.currencyPickerView.hidden = !self.currencyPickerView.hidden;
    self.isExpanded = !self.currencyPickerView.hidden;
    
    [self.delegate updateTableViewCellFrame:self];
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [NSLocale commonISOCurrencyCodes].count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.font = [UIFont fontWithName:SLHelveticaNeueFontName size:14.0f];
        tView.textColor = [UIColor textFieldDarkGrayColor];
        tView.textAlignment = NSTextAlignmentCenter;
    }
    tView.text = [self localeCurrencyStringForRow:row];
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.currencyButton setTitle:[self localeCurrencyStringForRow:row] forState:UIControlStateNormal];
    self.advertisement.currency = [NSLocale commonISOCurrencyCodes][row];
}

#pragma mark - Helpers

- (NSString *)localeCurrencyStringForRow:(NSInteger)row {
    NSString *localeCode = [NSLocale commonISOCurrencyCodes][row];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:localeCode];
    NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:localeCode]];
    
    return [NSString stringWithFormat:@"%@ (%@)", currencySymbol, localeCode];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSInteger touchedViewTag = touch.view.tag;
    
    if (touchedViewTag == SLTouchableImageViewTag) {
        [self.delegate tableViewCell:self
        advertisementImageViewTapped:self.photoImageView];
    }
}

- (BOOL)isEnteredDataValid {
    BOOL isImageValid = self.photoImageView.image != nil;
    
    if (!isImageValid) {
        [self.photoImageView shake];
        [self.photoIconImageView shake];
    }
    
    [self.emailTextField validate];
    [self.firstNameTextField validate];
    [self.phoneTextField validate];
    [self.priceTextField validate];
    
    return self.emailTextField.isValid &&
    self.firstNameTextField.isValid &&
    self.phoneTextField.isValid &&
    self.priceTextField.isValid &&
    isImageValid;
}

- (void)updateTextFieldsMandatoryValue {
    self.phoneTextField.isMandatory = !self.emailTextField.text.length;
    self.emailTextField.isMandatory = !self.phoneTextField.text.length;
}

#pragma mark - UITextFieldDelegate

- (IBAction)textFieldDidChange:(UITextField *)textField {
    [self updateTextFieldsMandatoryValue];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self updateTextFieldsMandatoryValue];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case SLTextFieldTypeUsername:
            self.advertisement.ownerName = textField.text;
            break;
        case SLTextFieldTypePhoneNumber:
            self.advertisement.phoneNumber = textField.text;
            break;
        case SLTextFieldTypeEmail:
            self.advertisement.email = textField.text;
            break;
        case SLTextFieldTypePrice:
            self.advertisement.price = [textField.text floatValue];
            break;
        default:
            break;
    }
}


@end
