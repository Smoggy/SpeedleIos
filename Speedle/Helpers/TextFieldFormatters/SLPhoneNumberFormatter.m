//
//  SLPhoneNumberFormatter.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/14/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLPhoneNumberFormatter.h"
#import "RMPhoneFormat.h"

@implementation SLPhoneNumberFormatter

- (NSString *)formatText:(NSString *)text isBackspacePressed:(BOOL)isBackspace {
    RMPhoneFormat *fmt = [[RMPhoneFormat alloc] init];
    return isBackspace ? text : [fmt format:text];
}

@end
