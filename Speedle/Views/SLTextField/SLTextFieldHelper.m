
//
//  SLTextFieldValidatorSupport.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/14/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLTextFieldHelper.h"

@implementation SLTextFieldHelper

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return ![self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)] || [self.delegate textFieldShouldBeginEditing:textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.delegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return ![self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)] || [self.delegate textFieldShouldEndEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.textFormatter) {
        NSString* totalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        id formattedString = [self.textFormatter formatText:totalString isBackspacePressed:range.length == 1];
        
        if ([formattedString isKindOfClass:[NSString class]]) {
            textField.text = formattedString;
        } else {
            textField.attributedText = formattedString;
        }
        
        if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
        }
        return NO;
    }

    return ![self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)] || [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return ![self.delegate respondsToSelector:@selector(textFieldShouldClear:)] || [self.delegate textFieldShouldClear:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.delegate textFieldShouldReturn:textField];
    }
    
    [textField resignFirstResponder];
    return YES;
}

@end
