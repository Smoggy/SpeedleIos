//
//  SLHTTPConstants.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTTPStatusCode) {
    HTTPStatusCodeOK = 200,
    HTTPStatusCodeNotFound = 404,
    HTTPStatusCodeUnauthorized = 401,
    HTTPStatusCodeBadParams = 422,
    HTTPStatusCodeCanceled = -999
};

extern NSString *const HTTPMethodGET;
extern NSString *const HTTPMethodPOST;
extern NSString *const HTTPMethodPUT;
extern NSString *const HTTPMethodDELETE;
