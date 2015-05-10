//
//  SLFacebookUtility.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/5/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLFacebookUtility.h"
#import "SLAdvert.h"
#import <AWSCore.h>
#import "SLSessionTokenCachingStrategy.h"

@interface SLFacebookUtility()
@property (strong, nonatomic) ACAccountStore *accountStore;
@end

@implementation SLFacebookUtility

#pragma mark - Initialization

- (ACAccountStore *)accountStore {
    if (!_accountStore) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return _accountStore;
}

#pragma mark - Login

- (void)showMessage:(NSString *)message withTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error {
    if (!error && state == FBSessionStateOpen) {
        NSLog(@"Session opened");
        NSString *facebookToken = [FBSession activeSession].accessTokenData.accessToken;
        
        AWSCognitoCredentialsProvider *provider = [AWSServiceManager defaultServiceManager].defaultServiceConfiguration.credentialsProvider;
        provider.logins = @{@(AWSCognitoLoginProviderKeyFacebook) : facebookToken};
        
        if (self.handler) {
            self.handler(facebookToken, nil);
        }
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed) {
        NSLog(@"Session closed");
        if (self.handler) {
            self.handler(nil, nil);
        }
    }
    [self handleError:error withState:state];
}

- (void)handleError:(NSError *)error withState:(FBSessionState)state {
    if (error) {
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        if ([FBErrorUtility shouldNotifyUserForError:error]) {
            alertTitle = NSLocalizedString(@"Something went wrong", nil);
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
            } else if ([FBErrorUtility errorCategoryForError:error] ==
                       FBErrorCategoryAuthenticationReopenSession) {
                alertTitle = NSLocalizedString(@"Session Error", nil);
                alertText = NSLocalizedString(@"Your current session is no longer valid. Please log in again.", nil);
                [self showMessage:alertText withTitle:alertTitle];
            } else {
                NSDictionary *errorInformation =
                (error.userInfo)[@"com.facebook.sdk:ParsedJSONResponseKey"][@"body"][@"error"];
                alertTitle = NSLocalizedString(@"Something went wrong", nil);
                alertText = [NSString
                             stringWithFormat:NSLocalizedString(@"Please retry. \n\n If the problem persists "
                                                                @"contact us and mention this error code: %@",
                                                                nil),
                             errorInformation[@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        [self finishingHandleError:error withState:state];
    }
}

- (void)finishingHandleError:(NSError *)error withState:(FBSessionState)state {
    if (state == FBSessionStateOpen || state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    if (self.handler) {
        self.handler(nil, error);
    }
}

- (void)openSessionWithHandler:(FacebookUtilityCompletion)handler {
    self.handler = handler;
    [self loadUserAccountFromSetingsWithCompletion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                ACAccountType *fbAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
                NSArray *accounts = [self.accountStore accountsWithAccountType:fbAccountType];
                if (accounts.count) {
                    [self finishPickingWithAccount:[accounts firstObject]];
                } else {
                    [self openSessionUsingSDK];
                }
            } else {
                [self openSessionUsingSDK];
            }
        });
    }];
}

- (void)openSessionUsingSDK {
    NSArray *permissions = @[ @"public_profile", @"email", @"user_friends", @"publish_actions" ];

    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    } else if (FBSession.activeSession.state == FBSessionStateOpen ||
               FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        if (self.handler) {
            self.handler([FBSession activeSession].accessTokenData.accessToken, nil);
        }
    } else {
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          [self sessionStateChanged:session state:status error:error];
                                      }];
    }
}

- (void)loadUserAccountFromSetingsWithCompletion:(ACAccountStoreRequestAccessCompletionHandler)completion {
    ACAccountType *fbAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *facebookInfo = @{
                                   ACFacebookAppIdKey : @"334648210018659",
                                   ACFacebookPermissionsKey : @[@"email"],
                                   ACFacebookAudienceKey : ACFacebookAudienceFriends
                                   };
    
    [self.accountStore requestAccessToAccountsWithType:fbAccountType
                                               options:facebookInfo
                                            completion:completion];
}

- (void)closeSession {
    self.handler = nil;
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
}

- (void)chooseAccountAlertControllerForAccounts:(NSArray *)accounts {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose account to proceed", @"Choose account to proceed")
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil]];
    
    for (ACAccount *account in accounts) {
        [alertController addAction:[UIAlertAction actionWithTitle:account.username
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [self finishPickingWithAccount:account];
                                                          }]];
    }
    UINavigationController *viewController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [viewController.visibleViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)finishPickingWithAccount:(ACAccount *)account {
    NSArray *permissions = @[ @"public_profile", @"email", @"user_friends", @"publish_actions" ];
    ACAccountCredential *fbCredential = [account credential];
    NSString *accessToken = [fbCredential oauthToken];
    
    SLSessionTokenCachingStrategy *cachingStrategy = [[SLSessionTokenCachingStrategy alloc] initWithToken:accessToken permissions:permissions];
    
    FBSession *session = [[FBSession alloc] initWithAppID:@"334648210018659"
                                              permissions:permissions
                                          urlSchemeSuffix:@"fb334648210018659"
                                       tokenCacheStrategy:cachingStrategy];
    
    if ([[FBSession activeSession].accessTokenData.accessToken isEqualToString:accessToken]) {
        [self openSessionUsingSDK];
    } else {
        [FBSession setActiveSession:session];
        [session openWithBehavior:FBSessionLoginBehaviorWithFallbackToWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            [self sessionStateChanged:session state:status error:error];
        }];
    }
}

#pragma mark - Sharing

- (void)shareAdvertisement:(SLAdvert *)advert {
    SLImage *image = [advert.imagesList firstObject];
    NSMutableDictionary *params = [@{@"name" : advert.advertName,
            @"caption" : advert.advertInfo,
            @"description" : advert.advertInfo,
            @"link" : [NSString stringWithFormat:@"www.speedle.se/classifieds/%@", advert.advertId],
            @"picture" : image.URLString} mutableCopy];
    
    [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  NSLog(@"result: %@", result);
                              } else {
                                  NSLog(@"%@", error.description);
                              }
                          }];
}

@end
