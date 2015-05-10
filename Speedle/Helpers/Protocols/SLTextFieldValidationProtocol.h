//
//  SLTextFieldValidationProtocol.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/15/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

@protocol SLTextFieldValidationProtocol <NSObject>

@property (nonatomic, assign) BOOL isMandatory;
@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, strong) NSString *regexString;

- (void)validate;

@end