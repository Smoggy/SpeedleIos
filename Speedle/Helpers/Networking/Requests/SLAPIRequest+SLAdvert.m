//
//  SLAPIRequest+SLAdvert.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/6/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAPIRequest+SLAdvert.h"
#import "SLAdvert.h"
#import "SLUser.h"
#import "UIImage+SLDiskSaving.h"
#import "SLUtilityFactory.h"

#import "SLAWSConstants.h"
#import "S3.h"
#import "DynamoDB.h"
#import "SQS.h"
#import "SNS.h"

#import <M13ProgressHUD.h>

@implementation SLAPIRequest (SLAdvert)

- (void)createAdvert:(SLAdvert *)advert {
    if (self.progressHUDDelegate) {
        [self.progressHUDDelegate showProgressHUD];
    }
    [self uploadImages:[advert.pickedImage writeImageToCachesPath] withCompletionHandler:^(id response, NSError *error) {
        if (self.progressHUDDelegate) {
            [self.progressHUDDelegate updateHUDLabelText:NSLocalizedString(@"Posting", nil)];
        }
        SLImage *advertImage = [[SLImage alloc] init];
        advertImage.URLString = [response firstObject];
        [advert.imagesList addObject:advertImage];
        
        SLImage *thumbImage = [[SLImage alloc] init];
        thumbImage.URLString = [response lastObject];
        [advert.thumbnailsList addObject:thumbImage];
        
        NSMutableDictionary *params = [[advert JSONDictionary] mutableCopy];
        SLAPIRequest *advertRequest = [[SLAPIRequest alloc] initTokenRequestWithAction:SLAPIClassifiedsKeyPath
                                                                                params:params
                                                                                method:HTTPMethodPOST];
        [advertRequest startWithCompetionHandler:^(id response, NSError *error) {
            if (!error) {
                if (self.progressHUDDelegate) {
                    [self.progressHUDDelegate hideProgressHUDWithSuccess];
                }
            } else {
                if (self.progressHUDDelegate) {
                    [self.progressHUDDelegate hideProgressHUDWithError];
                }
                NSLog(@"Error creating advert: %@", error);
            }
        }];
    }];
}

- (void)updateAdvert:(SLAdvert *)advert {
    if (self.progressHUDDelegate) {
        [self.progressHUDDelegate showProgressHUD];
    }
    
    SLAPICompletionHandler handler = ^(id response, NSError *error) {
        if (self.progressHUDDelegate) {
            [self.progressHUDDelegate updateHUDLabelText:NSLocalizedString(@"Posting", nil)];
        }
        if (response) {
            SLImage *advertImage = [[SLImage alloc] init];
            advertImage.URLString = [response firstObject];
            [advert.imagesList addObject:advertImage];
            
            SLImage *thumbImage = [[SLImage alloc] init];
            thumbImage.URLString = [response lastObject];
            [advert.imagesList addObject:thumbImage];
        }
        
        NSMutableDictionary *params = [[advert JSONDictionary] mutableCopy];
        SLAPIRequest *advertRequest = [[SLAPIRequest alloc] initTokenRequestWithAction:[NSString stringWithFormat:SLAPIClassifiedKeyPath, advert.advertId]
                                                                                params:params
                                                                                method:HTTPMethodPUT];
        [advertRequest startWithCompetionHandler:^(id response, NSError *error) {
            if (!error) {
                if (self.progressHUDDelegate) {
                    [self.progressHUDDelegate hideProgressHUDWithSuccess];
                }
            } else {
                if (self.progressHUDDelegate) {
                    [self.progressHUDDelegate hideProgressHUDWithError];
                }
                NSLog(@"Error updating advert: %@", error);
            }
        }];
    };
    
    if (advert.pickedImage) {
        [self uploadImages:[advert.pickedImage writeImageToCachesPath] withCompletionHandler:handler];
    } else {
        handler(nil, nil);
    }
}

- (void)uploadImages:(NSArray *)imageURLs withCompletionHandler:(SLAPICompletionHandler)completionHandler {
    if (self.progressHUDDelegate) {
        [self.progressHUDDelegate updateHUDLabelText:NSLocalizedString(@"Uploading photo", nil)];
    }
    
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    AWSS3TransferManagerUploadRequest *imageUploadRequest = [self uploadRequestForURL:[imageURLs firstObject] isThumb:NO];
    
    imageUploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (self.progressHUDDelegate) {
            [self.progressHUDDelegate updateHUDProgress:(totalBytesSent / totalBytesExpectedToSend)];
        }
    };
    
    AWSS3TransferManagerUploadRequest *thumbUploadRequest = [self uploadRequestForURL:[imageURLs lastObject] isThumb:YES];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [[transferManager upload:imageUploadRequest] continueWithBlock:^id(BFTask *task) {
        dispatch_group_leave(group);
        return nil;
    }];
    
    dispatch_group_enter(group);
    [[transferManager upload:thumbUploadRequest] continueWithBlock:^id(BFTask *task) {
        dispatch_group_leave(group);
        return nil;
    }];
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^ {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *imagelink = [NSString stringWithFormat:@"%@/%@", SLAWSEndpoint, imageUploadRequest.key];
            NSString *thumblink = [NSString stringWithFormat:@"%@/%@", SLAWSEndpoint, thumbUploadRequest.key];
            completionHandler(@[imagelink, thumblink], nil);
        });
    });
}

- (AWSS3TransferManagerUploadRequest *)uploadRequestForURL:(NSURL *)imageURL isThumb:(BOOL)isThumb {
    NSError *error = NULL;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:imageURL.path
                                                                                error:&error];
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.bucket = SLBucketName;
    NSInteger interval = round([NSDate timeIntervalSinceReferenceDate]);
    NSString *thumbPostfix = isThumb ? @"-thumb" : @"";
    NSString *keyValue = [NSString stringWithFormat:@"%@/%ld%@.jpeg", [SLUser currentUser].userId, (long)interval, thumbPostfix];
    uploadRequest.key = keyValue;
    uploadRequest.body = imageURL;
    uploadRequest.contentLength = @([attributes fileSize]);
    uploadRequest.contentType = @"image/jpeg";
    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
    
    return uploadRequest;
}

+ (SLAPIRequest *)allClassifieds {
    SLAPIRequest *classifiedRequest = [[SLAPIRequest alloc] initTokenRequestWithAction:SLAPIClassifiedsKeyPath];
    return classifiedRequest;
}

+ (SLAPIRequest *)currentUserClassifieds {
    NSString *action = [NSString stringWithFormat:SLAPIClassifiedsForUserKeyPath, [SLUser currentUser].userId];
    SLAPIRequest *myAdsRequest = [[SLAPIRequest alloc] initWithAction:action];
    return myAdsRequest;
}

+ (SLAPIRequest *)deleteClassifiedWithId:(NSString *)classifiedId {
    SLAPIRequest *deleteRequest = [[SLAPIRequest alloc] initTokenRequestWithAction:[NSString stringWithFormat:SLAPIClassifiedKeyPath, classifiedId]
                                                                            params:nil
                                                                            method:HTTPMethodDELETE];
    return deleteRequest;
}

+ (SLAPIRequest *)classifiedsForCurrentLocationWithQuery:(NSString *)query category:(SLCategory *)category skip:(NSInteger)skip {
    CLLocation *currentLocation = [[SLUtilityFactory sharedInstance] locationUtility].currentLocation;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                    SLAPILatitudeKey : @(currentLocation.coordinate.latitude),
                                                                                    SLAPILongitudeKey : @(currentLocation.coordinate.longitude),
                                                                                    SLAPISkipKey : @(skip),
                                                                                    SLAPILimitKey : @(SLAPIDefaultClassifiedsLimit),
                                                                                    SLAPIRadiusKey : [NSNumber numberWithInt:[SLUser currentUser].radiusSetting*1000]
                                                                                    }];
    
    
    if (query) {
        params[SLAPIQueryKey] = query;
    }
    
    if (category) {
        params[SLAPICategoriesKey] = category.categoryId;
    }
    
    SLAPIRequest *classifiedsRequest = [[SLAPIRequest alloc] initTokenRequestWithAction:SLAPIClassifiedsKeyPath
                                                                                 params:params
                                                                                 method:HTTPMethodGET];
    return classifiedsRequest;
}

+ (SLAPIRequest *)postAnAbuse:(SLAdvert *)advert {
    NSDictionary *params = @{SLAPIClassifiedKey : advert.advertId};
    SLAPIRequest *abuseRequest = [[SLAPIRequest alloc] initTokenRequestWithAction:SLAPIClassifiedsAbuseKeyPath
                                                                           params:params
                                                                           method:HTTPMethodPOST];
    return abuseRequest;
}

@end
