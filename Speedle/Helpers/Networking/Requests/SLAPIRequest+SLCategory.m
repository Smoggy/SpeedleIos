//
//  SLAPIRequest+SLCategory.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/13/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAPIRequest+SLCategory.h"
#import "SLCategory.h"

@implementation SLAPIRequest (SLCategory)

+ (SLAPIRequest *)updateCategories {
    SLAPIRequest *categoriesRequest = [[SLAPIRequest alloc] initWithAction:SLAPICategoriesKeyPath
                                                                    params:nil
                                                                    method:HTTPMethodGET];
    
    categoriesRequest.completionHandler = ^(NSArray *response, NSError *error){
        if (!error) {
            [SLCategory createOrUpdateCategoriesWithResponse:response];
        } else {
            NSLog(@"Error updating categories %@", error);
        }
    };
    return categoriesRequest;
}

@end
