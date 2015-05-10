//
//  AppDelegate.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/5/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <AFNetworkActivityLogger.h>
#import <AFNetworkActivityIndicatorManager.h>

#import "SLConstants.h"
#import "SLApiClient.h"
#import "SLUtilityFactory.h"
#import "SLAPIRequest+SLCategory.h"

#import "AWSCore.h"
#import "SLAWSConstants.h"
#import <GPPSignIn.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation SLAppDelegate

+ (SLAppDelegate *)sharedInstance {
    return (SLAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [GPPSignIn sharedInstance].clientID = @"1085389526820-j749ni0i50v8q1cmim8ubmehlhakl140.apps.googleusercontent.com";
    
    [self showRootViewController];
    [self setupLocationManager];
    [self setupNetworkManagers];
    
    [self configureAWSCore];
    [Fabric with:@[CrashlyticsKit]];
    return YES;
}

- (void)showRootViewController {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *viewControllerId = SLAuthorizationViewControllerIdentifier;
    if ([SLApiClient sharedClient].accessToken.length) {
        viewControllerId = SLTabbarViewControllerIdentifier;
        [[SLApiClient sharedClient] renewCredentials];
    }
    [[SLAPIRequest updateCategories] start];
    UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:viewControllerId];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
}

- (void)setupNetworkManagers {
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


- (void)configureAWSCore {
    NSDictionary *logins = nil;
    if ([FBSession activeSession].accessTokenData) {
        logins = @{@(AWSCognitoLoginProviderKeyFacebook) : [FBSession activeSession].accessTokenData.accessToken};
    }
    AWSCognitoCredentialsProvider *credentialsProvider = [AWSCognitoCredentialsProvider credentialsWithRegionType:AWSRegionEUWest1
                                                                                                        accountId:SLAWSAccountID
                                                                                                   identityPoolId:SLCognitoPoolID
                                                                                                    unauthRoleArn:nil
                                                                                                      authRoleArn:SLRoleArn];
    credentialsProvider.logins = logins;
    AWSServiceConfiguration *configuration = [AWSServiceConfiguration
                                              configurationWithRegion:AWSRegionEUWest1
                                              credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
}

- (void)setupLocationManager {
    [[SLUtilityFactory sharedInstance] locationUtility];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[[SLUtilityFactory sharedInstance] facebookUtility] handler] == NULL) {
        [FBSession.activeSession setStateChangeHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            [[[SLUtilityFactory sharedInstance] facebookUtility] sessionStateChanged:session state:state error:error];
            if (state == FBSessionStateOpen || state == FBSessionStateOpenTokenExtended) {
                [[FBSession activeSession] closeAndClearTokenInformation];
            }
        }];
    }
    
    if ([[url scheme] isEqualToString:@"fb334648210018659"]) {
        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    } else {
        return [[GPPSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
}

@end
