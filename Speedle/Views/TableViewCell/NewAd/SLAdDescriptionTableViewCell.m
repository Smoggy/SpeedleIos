
//
//  SLAdDescriptionTableViewCell.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/15/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAdDescriptionTableViewCell.h"
#import "SLRegexConstants.h"
#import "SLTextView.h"
#import "SLAdvert.h"
#import "UIColor+SLExtensions.h"

@interface SLAdDescriptionTableViewCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property (weak, nonatomic) IBOutlet UITextField *blankTextField;
@property (weak, nonatomic) IBOutlet SLTextView *descriptionTextView;
@property (assign, nonatomic) BOOL isOpened;
@end

@implementation SLAdDescriptionTableViewCell
@synthesize advertisement = _advertisement;

- (void)awakeFromNib {
    self.descriptionTextView.regexString = SLDescriptionRegularExpression;
    self.previewButton.layer.borderColor = [self.previewButton.titleLabel.textColor CGColor];
    self.descriptionTextView.placeholder = NSLocalizedString(@"Description", nil);
}

- (void)setButtonStyle:(SLAdDescriptionCellButtonStyle)buttonStyle {
    _buttonStyle = buttonStyle;
    
    if (buttonStyle == SLAdDescriptionCellButtonStyleRemove) {
        [self.previewButton setTitleColor:[UIColor destructiveRedColor] forState:UIControlStateNormal];
        [self.previewButton setTitle:NSLocalizedString(@"Remove Ad", nil) forState:UIControlStateNormal];
        self.previewButton.layer.borderColor = [[UIColor destructiveRedColor] CGColor];
    }
}

- (void)setAdvertisement:(SLAdvert *)advertisement {
    _advertisement = advertisement;
    self.descriptionTextView.text = advertisement.advertDescription;
}

- (BOOL)isEnteredDataValid {
    [self.descriptionTextView validate];
    return self.descriptionTextView.isValid;
}

- (IBAction)previewButtonPressed:(id)sender {
    [self.delegate tableViewCell:self previewButtonTapped:sender];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (!self.isOpened) {
        self.isOpened = YES;
        [self.blankTextField becomeFirstResponder];
        [self.blankTextField resignFirstResponder];
        
        [self.descriptionTextView becomeFirstResponder];
    } else {
        self.isOpened = NO;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.advertisement.advertDescription = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
