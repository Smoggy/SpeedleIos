//
//  SLTextFieldTextFormatter.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/14/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLTextFieldTextFormatter : NSObject
- (id)formatText:(NSString *)text isBackspacePressed:(BOOL)isBackspace;
@end
