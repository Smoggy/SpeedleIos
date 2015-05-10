
//
//  SLPersonalSettingsViewController.m
//  Speedle
//
//  Created by Vova Pogrebnyak on 1/13/15.
//  Copyright (c) 2015 Bryderi. All rights reserved.
//

#import "SLPersonalSettingsViewController.h"
#import "SLTextField.h"
#import "SLUser.h"
#import "SLAPIRequest+SLUser.h"
#import "SLRegexConstants.h"

typedef NS_ENUM(NSInteger, SLTextFieldType) {
    SLTextFieldTypeUsername,
    SLTextFieldTypePhoneNumber,
    SLTextFieldTypeEmail
};

@interface SLPersonalSettingsViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet SLTextField *nameTextField;
@property (weak, nonatomic) IBOutlet SLTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet SLTextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) SLUser *initialUser;

@property(strong, nonatomic) UITapGestureRecognizer *keyboardTapRecognizer;
@end

@implementation SLPersonalSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.initialUser = [SLUser currentUser];
    [self updateTextFields];
    
    self.keyboardTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(triggersKeyboardRecognizer:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view addGestureRecognizer:self.keyboardTapRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view removeGestureRecognizer:self.keyboardTapRecognizer];
}

- (void)updateTextFields {
    SLUser *user = [SLUser currentUser];
    
    self.nameTextField.text = user.username;
    self.emailTextField.text = user.email;
    self.phoneTextField.text = user.phoneNumber;
    
    self.emailTextField.regexString = SLEmailRegularExpression;
    self.phoneTextField.regexString = SLPhoneNumberRegularExpression;
    self.nameTextField.regexString = SLUsernameRegularExpression;
    [self updateTextFieldsMandatoryValue];
}

- (IBAction)saveButtonPressed:(id)sender {
    if ([self isEnteredDataValid]) {
        [self updateLoadingRightBarButtonItem];
        
        SLUser *user = [SLUser currentUser];
        RLMRealm *realm = [RLMRealm defaultRealm];

        [realm beginWriteTransaction];
        user.username = self.nameTextField.text;
        user.email = self.emailTextField.text;
        user.phoneNumber = self.phoneTextField.text;
        [realm commitWriteTransaction];
        
        SLAPIRequest *updateUserRequest = [SLAPIRequest updateCurrentUserInfo];
        [updateUserRequest startWithCompetionHandler:^(id response, NSError *error) {
            [self updateNormalRightBarButtonItem];
            if (!error) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"Error updating user info :%@", error);
            }
        }];
    }
}

- (void)updateLoadingRightBarButtonItem {
    UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [activityView sizeToFit];
    [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    [activityView startAnimating];
    [self.navigationItem setRightBarButtonItem:loadingView];
}

- (void)updateNormalRightBarButtonItem {
    [self.navigationItem setRightBarButtonItem:self.saveButton];
}

- (BOOL)isEnteredDataValid {
    [self.emailTextField validate];
    [self.phoneTextField validate];
    [self.nameTextField validate];
    
    return self.emailTextField.isValid &&
    self.nameTextField.isValid &&
    self.phoneTextField.isValid;
}

- (void)updateTextFieldsMandatoryValue {
    self.phoneTextField.isMandatory = !self.emailTextField.text.length;
    self.emailTextField.isMandatory = !self.phoneTextField.text.length;
}

- (void)triggersKeyboardRecognizer:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateTextFieldsMandatoryValue];
    });
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateTextFieldsMandatoryValue];
    });
    return YES;
}

@end
