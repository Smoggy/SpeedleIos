//
//  SLPriceFormatter.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/16/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLPriceFormatter.h"
#import <UIKit/UIKit.h>
#import <CoreText/CTStringAttributes.h>
#import "SLFontConstants.h"

@implementation SLPriceFormatter

static NSInteger SLNumberOfCharsAfterDot = 2;

- (NSAttributedString *)formatText:(NSString *)text isBackspacePressed:(BOOL)isBackspace {
    NSString *dotSymbol = @".";
    NSRange dotRange = [text rangeOfString:dotSymbol];
    
    if (dotRange.location == NSNotFound && [text rangeOfString:@","].location != NSNotFound) {
        dotSymbol = @",";
        dotRange = [text rangeOfString:dotSymbol];
    }
    
    NSInteger dotLocation = dotRange.location;
    NSInteger nextSymbolLocation = dotLocation + 1;
    
    if (nextSymbolLocation < text.length) {
        text = [text stringByReplacingOccurrencesOfString:@"."
                                               withString:@""
                                                  options:0
                                                    range:NSMakeRange(nextSymbolLocation, text.length - nextSymbolLocation)];
    }
    
    if (dotLocation != NSNotFound) {
        if (dotLocation == 0) {
            text = [NSString stringWithFormat:@"0%@", text];
            dotLocation ++;
        } else {
            NSUInteger afterDotStringLenght = [text substringFromIndex:nextSymbolLocation].length;
            if (afterDotStringLenght > SLNumberOfCharsAfterDot) {
                text = [text substringToIndex:nextSymbolLocation + SLNumberOfCharsAfterDot];
            }
        }
    }
    
    NSMutableAttributedString *cleanString = [[NSMutableAttributedString alloc] initWithString:text];
    
    if (dotRange.location != NSNotFound && [text substringFromIndex:nextSymbolLocation].length > 0) {
        NSRange afterDotStringRange = NSMakeRange(nextSymbolLocation, [text substringFromIndex:nextSymbolLocation].length);
        [cleanString addAttribute:(__bridge NSString *)kCTSuperscriptAttributeName
                            value:@1
                            range:afterDotStringRange];
        [cleanString addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:SLHelveticaNeueLightFontName size:10.0f]
                            range:afterDotStringRange];
    }
    
    return cleanString;
}

@end
