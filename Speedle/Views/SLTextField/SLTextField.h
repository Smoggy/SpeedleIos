//
//  SLTextField.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/12/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLTextFieldValidationProtocol.h"
#import "SLTextFieldHelper.h"

@interface SLTextField : UITextField <SLTextFieldValidationProtocol>
@property (strong, nonatomic) SLTextFieldHelper *textFieldValidatorSupport;
@end
