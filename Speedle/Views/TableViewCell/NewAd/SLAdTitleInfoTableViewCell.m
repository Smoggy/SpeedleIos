
//
//  SLAdAdditionalInfoTableViewCell.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/12/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAdTitleInfoTableViewCell.h"
#import "SLTextField.h"
#import "SLRegexConstants.h"
#import "SLAdvert.h"

@interface SLAdTitleInfoTableViewCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet SLTextField *titleTextField;
@end

@implementation SLAdTitleInfoTableViewCell
@synthesize advertisement = _advertisement;

- (void)awakeFromNib {
    self.titleTextField.regexString = SLTitleRegularExpression;
}

- (void)setAdvertisement:(SLAdvert *)advertisement {
    _advertisement = advertisement;
    self.titleTextField.text = advertisement.advertName;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.advertisement.advertName = textField.text;
}

- (BOOL)isEnteredDataValid {
    [self.titleTextField validate];
    
    return self.titleTextField.isValid;
}

@end
