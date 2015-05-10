//
//  SLAdTableViewCellValidationProtocol.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/15/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

@class SLAdvert;

@protocol SLAdTableViewCellValidationProtocol <NSObject>
@property (nonatomic, strong) SLAdvert *advertisement;
- (BOOL)isEnteredDataValid;
@end