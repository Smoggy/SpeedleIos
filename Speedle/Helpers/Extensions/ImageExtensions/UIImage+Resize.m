//
//  UIImage+Resize.m
//  TooNight
//
//  Created by Gerasymenko Yevgen on 29.04.14.
//  Copyright (c) 2014 Gerasymenko Yevgen. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)tn_resizeInRect:(NSInteger)rect {
    CGRect rectResize = CGRectMake(0,0,rect,rect);
    UIGraphicsBeginImageContext( rectResize.size );
    [self drawInRect:rectResize];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(picture1);
    UIImage *img=[UIImage imageWithData:imageData];
    return  img;
}

- (UIImage *)tn_resizeInWidth:(NSInteger)width height:(NSInteger)height {
    CGRect rectResize = CGRectMake(0,0,width,height);
    UIGraphicsBeginImageContext( rectResize.size );
    [self drawInRect:rectResize];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(picture1, 1.0);
    UIImage *img=[UIImage imageWithData:imageData];
    return  img;
}

- (UIImage *)tn_rectForImageView:(UIImageView *)imageView {
    UIImage *image = [self tn_fixrotation:self];
    float kof = 0;
    int width, height;
    if (image.size.width > image.size.height) {
        height = image.size.height;
        kof = imageView.frame.size.height/image.size.height;
        width = imageView.frame.size.width/kof;
    }
    else {
        width = image.size.width;
        kof = imageView.frame.size.width/image.size.width;
        height = imageView.frame.size.height/kof;
    }
    CGRect croprect  = CGRectMake(image.size.width/2 - width/2,
                                  image.size.height/2 - height/2,
                                  width,
                                  height);
    CGImageRef subImage = CGImageCreateWithImageInRect (image.CGImage,croprect);
    UIImage *rezultImage = [UIImage imageWithCGImage:subImage];
    CGImageRelease(subImage);
    return rezultImage;
}

- (UIImage *)tn_specialRect:(UIImageView *)imageView {
    UIImage *image = [self tn_fixrotation:self];
    float kof = 0;
    int width, height;
    width = image.size.width;
    kof = imageView.frame.size.width/image.size.width;
    height = imageView.frame.size.height/kof;
    CGRect croprect  = CGRectMake(image.size.width/2 - width/2,
                                  image.size.height/2 - height/2,
                                  width,
                                  height);
    CGImageRef subImage = CGImageCreateWithImageInRect (image.CGImage,croprect);
    UIImage *rezultImage = [UIImage imageWithCGImage:subImage];
    CGImageRelease(subImage);
    return rezultImage;
}

- (UIImage *)tn_resizedImage:(UIImage *)inImage toRect:(CGRect)thumbRect {
    inImage = [inImage tn_fixrotation:inImage];
    CGImageRef imageRef = [inImage CGImage];
    CGBitmapInfo	alphaInfo = CGImageGetBitmapInfo(imageRef);
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                thumbRect.size.width,
                                                thumbRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                4 * thumbRect.size.width,
                                                CGImageGetColorSpace(imageRef),
                                                alphaInfo);
    CGContextDrawImage(bitmap, thumbRect, imageRef);
    CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    return result;
}


- (UIImage *)tn_fixrotation:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)tn_captureScreenInRect:(CGRect)captureFrame {
    CALayer *layer;
    layer.contents = self;
    UIGraphicsBeginImageContext(self.size);
    CGContextClipToRect (UIGraphicsGetCurrentContext(),captureFrame);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

@end