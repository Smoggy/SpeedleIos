//
//  APPSLocationManagerUtility.m
//  Wazere
//
//  Created by iOS Developer on 10/28/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import "SLLocationManagerUtility.h"
#import "SLAPIRequest+SLUser.h"

@interface SLLocationManagerUtility () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *standartLocationManager;
@property (strong, nonatomic) CLLocationManager *significantLocationManager;
@property (copy, nonatomic) LocationManagerUtilityHandler handler;

@end

@implementation SLLocationManagerUtility

#pragma Location services

- (void)dealloc {
    [_standartLocationManager stopUpdatingLocation];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _significantLocationManager = [[CLLocationManager alloc] init];
        _significantLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [_significantLocationManager requestAlwaysAuthorization];
        _significantLocationManager.delegate = self;
        [_significantLocationManager startMonitoringSignificantLocationChanges];
    }
    return self;
}

- (BOOL)checkLocationServices {
    if (![CLLocationManager locationServicesEnabled]) {
        return NO;
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return !(status != kCLAuthorizationStatusAuthorizedAlways &&
    status != kCLAuthorizationStatusAuthorizedWhenInUse &&
    status != kCLAuthorizationStatusNotDetermined);
}

- (void)showLocationManagerErrorMessage {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:nil
                               message:NSLocalizedString(@"Location services is disabled", nil)
                              delegate:nil
                     cancelButtonTitle:NSLocalizedString(@"OK", nil)
                     otherButtonTitles:nil];
    [alert show];
}

- (void)startStandardUpdatesWithDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
                                 distanceFilter:(CLLocationDistance)distance
                                        handler:(LocationManagerUtilityHandler)handler {
    if (![self checkLocationServices]) {
        [self showLocationManagerErrorMessage];
        [self performHandlerWithLocation:nil
                                   error:[NSError errorWithDomain:@"SLLocationManagerUtility"
                                                             code:kLocationServiceUnaviableErrorCode
                                                         userInfo:@{
                                                                    NSLocalizedFailureReasonErrorKey :
                                                                        @"Location services unaviable"
                                                                    }]];
        return;
    }
    if (self.handler != NULL) {
        NSError *error =
        [NSError errorWithDomain:@"SLLocationManagerUtility"
                            code:1
                        userInfo:@{
                                   NSLocalizedFailureReasonErrorKey : @"Location manager already in use"
                                   }];
        NSLog(@"%@", error);
        [self performHandlerWithLocation:nil error:error];
        return;
    }
    self.handler = handler;
    if (nil == self.standartLocationManager) {
        self.standartLocationManager = [[CLLocationManager alloc] init];
        [self.standartLocationManager requestAlwaysAuthorization];
    }
    
    self.standartLocationManager.delegate = self;
    self.standartLocationManager.desiredAccuracy = desiredAccuracy;
    self.standartLocationManager.distanceFilter = distance;
    
    [self.standartLocationManager startUpdatingLocation];
}

- (void)performHandlerWithLocation:(CLLocation *)location error:(NSError *)error {
    if (self.handler) {
        self.handler(location, error);
    }
}

- (void)updateServerLocationInformation:(CLLocation *)location {
    if ([SLApiClient sharedClient].accessToken.length) {
        SLAPIRequest *updateLocationRequest = [SLAPIRequest updateUserLocation:location];
        [updateLocationRequest start];
    }
}

- (void)stopUpdates {
    self.handler = nil;
    [self.standartLocationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        if (location) {
            self.currentLocation = location;
            if (manager == self.significantLocationManager) {
                [self updateServerLocationInformation:location];
            }
        }
    }
    if (self.currentLocation == nil && location) {
        self.currentLocation = location;
        [self updateServerLocationInformation:location];
    }
    
    [self performHandlerWithLocation:location error:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    [self performHandlerWithLocation:nil error:error];
}

@end
