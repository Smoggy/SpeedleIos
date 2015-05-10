//
//  SLRegexConstants.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/14/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLRegexConstants.h"

NSString *const SLEmailRegularExpression = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
NSString *const SLUsernameRegularExpression = @"^.{1,30}$";
NSString *const SLPhoneNumberRegularExpression = @"^.{5,20}$";
NSString *const SLPriceRegularExpression = @"^.{1,}$";
NSString *const SLTitleRegularExpression = @"^.{1,30}$";
NSString *const SLDescriptionRegularExpression = @"^[\\S\\s]{1,500}$";