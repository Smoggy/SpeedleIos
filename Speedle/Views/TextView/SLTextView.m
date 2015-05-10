
//
//  SLTextView.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/14/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLTextView.h"
#import "SLFontConstants.h"
#import "UIColor+SLExtensions.h"
#import <UIView+Shake.h>

@implementation SLTextView
@synthesize isValid = _isValid, isMandatory = _isMandatory, regexString = _regexString;

static CGFloat const SLTextViewTextInset = 5.0f;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updatePlaceholder];
    self.textContainerInset = UIEdgeInsetsMake(SLTextViewTextInset, SLTextViewTextInset,
                                               SLTextViewTextInset, SLTextViewTextInset);
}

- (void)updatePlaceholder {
    if (self.placeholder) {
        NSMutableString *placeholderString = [[NSMutableString alloc] initWithString:self.placeholder];
        [placeholderString appendString:(self.isMandatory ? @" *" : @"")];
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholderString];
        NSRange attributesRange = NSMakeRange(0, placeholderString.length);
        [attributedPlaceholder addAttributes:@{
                                               NSFontAttributeName : [UIFont fontWithName:SLHelveticaNeueLightFontName size:15.0],
                                               NSForegroundColorAttributeName : [UIColor placeholderGrayColor]
                                               }
                                       range:attributesRange];
        self.attributedPlaceholder = attributedPlaceholder;
    }
}

- (void)setIsMandatory:(BOOL)isMandatory {
    _isMandatory = isMandatory;
    [self updatePlaceholder];
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
