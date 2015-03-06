//
//  SettingsViewController.m
//  PHSPowerSchool
//
//  Created by Ryan D'souza on 3/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "SettingsViewController.h"
#import "UICKeyChainStore.h"
#import "LoginToPowerSchoolViewController.h"

@interface SettingsViewController ()

@property (strong, nonatomic) IBOutlet UIView *popupView;

@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;
@property (strong, nonatomic) IBOutlet UILabel *studentAccountLabel;

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UISwitch *studentAccountSwitch;

@property (strong, nonatomic) UICKeyChainStore *keychain;

@property (strong, nonatomic) UIWebView *webView;

- (IBAction)saveSettings:(id)sender;

@end

@implementation SettingsViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil webView:(UIWebView *)webView
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.webView = webView;
    self.keychain = [[UICKeyChainStore alloc] init];
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

- (void)viewDidLoad
{
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.popupView.layer.cornerRadius = 5;
    self.popupView.layer.shadowOpacity = 0.8;
    self.popupView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    [super viewDidLoad];
    
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    if(self.keychain[@"username"] != nil) {
        self.usernameTextField.text = self.keychain[@"username"];
    }
    if(self.keychain[@"password"] != nil) {
        self.passwordTextField.text = self.keychain[@"password"];
    }
    if(self.keychain[@"isStudent"] != nil) {
        if([self.keychain[@"isStudent"] isEqualToString:@"YES"]) {
            [self.studentAccountSwitch setOn:YES animated:YES];
        }
        else {
            [self.studentAccountSwitch setOn:NO animated:YES];
        }
    }
}

- (void) showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void) showInView:(UIView *)view shouldAnimate:(BOOL)shouldAnimate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [view addSubview:self.view];
        
        if(shouldAnimate) {
            [self showAnimate];
        }
    });
}

- (void) removeAnimate
{
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //Add some glow effect
    textField.layer.cornerRadius = 8.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [[UIColor blueColor]CGColor];
    textField.layer.borderWidth = 2.0f;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //Remove the flow effect
    textField.layer.borderColor=[[UIColor clearColor]CGColor];
}

- (IBAction)saveSettings:(id)sender {
    self.keychain[@"username"] = self.usernameTextField.text;
    self.keychain[@"password"] = self.passwordTextField.text;
    self.keychain[@"isStudent"] = [self.studentAccountSwitch isOn] ? @"YES": @"NO";
    
    [self injectInformation:[self.studentAccountSwitch isOn] username:self.usernameTextField.text password:self.passwordTextField.text];
    [self removeAnimate];
}

- (void) injectInformation:(BOOL)isStudent username:(NSString*)username password:(NSString*)password {
    
    if(isStudent) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"ConfigureLoginBox('Student')"];
    }
    else {
        [self.webView stringByEvaluatingJavaScriptFromString:@"ConfigureLoginBox('Guardian')"];
    }
    
    NSString *loadUsernameJS = [NSString stringWithFormat:@"document.getElementsByName('account')[0].value='%@'", username];
    NSString *loadPasswordJS = [NSString stringWithFormat:@"document.getElementsByName('pw')[0].value='%@'", password];
    
    //autofill the form
    [self.webView stringByEvaluatingJavaScriptFromString: loadUsernameJS];
    [self.webView stringByEvaluatingJavaScriptFromString: loadPasswordJS];
}

@end
