//
//  SLPaginationManager.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/31/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLPaginationManager.h"
#import "SLAPIConstants.h"

@implementation SLPaginationManager

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    self.skipValue = SLAPIDefaultClassifiedsLimit * currentPage;
}

@end
