//
//  UIImage+SLDiskSaving.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/15/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SLDiskSaving)
- (NSArray *)writeImageToCachesPath;
@end
