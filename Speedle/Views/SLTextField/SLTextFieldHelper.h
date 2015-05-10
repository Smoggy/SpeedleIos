//
//  SLTextFieldValidatorSupport.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/14/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SLTextFieldTextFormatter.h"

@interface SLTextFieldHelper : NSObject <UITextFieldDelegate>

@property (nonatomic, weak) id<UITextFieldDelegate> delegate;
@property (nonatomic, strong) SLTextFieldTextFormatter *textFormatter;

@end
