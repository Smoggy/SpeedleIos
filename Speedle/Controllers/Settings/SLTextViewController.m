//
//  SLTextViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/9/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLTextViewController.h"

@interface SLTextViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SLTextViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.textView.contentOffset = CGPointZero;
}

@end
