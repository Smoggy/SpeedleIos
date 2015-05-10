
//
//  SLProgressHUDView.h
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/9/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLProgressHUDView : UIView

+ (SLProgressHUDView *)progressHUD;
- (void)showHUDAddedToTask:(NSURLSessionTask *)urlTask;

@end
