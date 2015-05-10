
//
//  SLTextField.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/12/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLTextField.h"
#import "SLFontConstants.h"

#import "UIColor+SLExtensions.h"
#import <UIView+Shake.h>

#import "SLPhoneNumberFormatter.h"
#import "SLPriceFormatter.h"

@implementation SLTextField
@synthesize isValid = _isValid, isMandatory = _isMandatory, regexString = _regexString;

static CGFloat const SLTextFieldTextInset = 10.0f;
static CGFloat const SLTextFieldCancelButtonInset = 12.0f;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updatePlaceholder];
    [self updateFormatters];
}

- (SLTextFieldHelper *)textFieldValidatorSupport {
    if (!_textFieldValidatorSupport) {
        _textFieldValidatorSupport = [[SLTextFieldHelper alloc] init];
    }
    return _textFieldValidatorSupport;
}

- (void)updatePlaceholder {
    if (self.placeholder) {
        NSMutableString *placeholderString = [[NSMutableString alloc] initWithString:self.placeholder];
        NSRange attributesRange = NSMakeRange(0, placeholderString.length);
        
        if (self.isMandatory) {
            NSString *asterix = [placeholderString hasSuffix:@" *"] ? @"" : @" *";
            [placeholderString appendString:asterix];
        } else {
            [placeholderString replaceOccurrencesOfString:@" *"
                                               withString:@""
                                                  options:NSBackwardsSearch
                                                    range:attributesRange];
            attributesRange = NSMakeRange(0, placeholderString.length);
        }
        
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholderString];
        [attributedPlaceholder addAttributes:@{
                                               NSFontAttributeName : [UIFont fontWithName:SLHelveticaNeueLightFontName size:15.0],
                                               NSForegroundColorAttributeName : [UIColor placeholderGrayColor]
                                               }
                                       range:attributesRange];
        self.attributedPlaceholder = attributedPlaceholder;
    }
}

- (void)updateFormatters {
    if (self.keyboardType == UIKeyboardTypePhonePad) {
        self.textFieldValidatorSupport.textFormatter = [[SLPhoneNumberFormatter alloc] init];
    }
    if (self.keyboardType == UIKeyboardTypeDecimalPad) {
        self.textFieldValidatorSupport.textFormatter = [[SLPriceFormatter alloc] init];
    }
}

- (void)setIsMandatory:(BOOL)isMandatory {
    _isMandatory = isMandatory;
    [self updatePlaceholder];
}

- (void)setText:(NSString *)text {
    [super setText:text ? text : @""];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect textRect = CGRectInset(bounds, SLTextFieldTextInset, 0.0f);
    textRect.size.width -= SLTextFieldCancelButtonInset;
    return textRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect textRect = CGRectInset(bounds, SLTextFieldTextInset, 0.0f);
    textRect.size.width -= SLTextFieldCancelButtonInset;
    return textRect;
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    self.textFieldValidatorSupport.delegate = delegate;
    [super setDelegate:self.textFieldValidatorSupport];
}

#pragma mark - Validation

- (void)validate {
    self.isValid = (!self.isMandatory && self.text.length == 0) || [self validateString:self.text];
    
    if (!self.isValid) {
        [self shake];
    }
}

- (BOOL)validateString:(NSString*)stringToSearch {
    if (self.regexString) {
        NSRange range = [stringToSearch rangeOfString:self.regexString options:NSRegularExpressionSearch];
        return range.location != NSNotFound && stringToSearch.length > 0;
    } else {
        return YES;
    }
}

@end
