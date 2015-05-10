//
//  UIImage+SLDiskSaving.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/15/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "UIImage+SLDiskSaving.h"
#import "SLUser.h"

@implementation UIImage (SLDiskSaving)

- (NSArray *)writeImageToCachesPath {
    NSData *initialImage = UIImageJPEGRepresentation(self, 0.0f);
    NSData *thumbnailImage = UIImageJPEGRepresentation([self compressForUpload:self :0.3], 0.0f);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = paths[0];
    NSInteger interval = round([NSDate timeIntervalSinceReferenceDate]);
    NSString *imageFileName = [NSString stringWithFormat:@"%@%ld.jpeg", [SLUser currentUser].userId, (long)interval];
    NSString *thumbnailFileName = [NSString stringWithFormat:@"%@%ld-thumb.jpeg", [SLUser currentUser].userId, (long)interval];
    
    NSString *imageFilePath = [documentsPath stringByAppendingPathComponent:imageFileName];
    [initialImage writeToFile:imageFilePath atomically:YES];
    
    NSString *thumbFilePath = [documentsPath stringByAppendingPathComponent:thumbnailFileName];
    [thumbnailImage writeToFile:thumbFilePath atomically:YES];
    
    NSArray *array = @[[NSURL fileURLWithPath:imageFilePath], [NSURL fileURLWithPath:thumbFilePath]];

    return array;
}

- (UIImage *)compressForUpload:(UIImage *)original :(CGFloat)scale {
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

@end
