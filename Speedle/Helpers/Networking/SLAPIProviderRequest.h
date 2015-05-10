//
//  SLAPIProviderRequest.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SLAPIProviderRequest <NSObject>
@required
- (NSString*)action;
- (NSDictionary*)parameters;
@end
