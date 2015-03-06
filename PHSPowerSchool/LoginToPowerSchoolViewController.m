//
//  LoginToPowerSchoolViewController.m
//  PHSPowerSchool
//
//  Created by Ryan D'souza on 3/5/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "LoginToPowerSchoolViewController.h"
#import "PQFBarsInCircle.h"
#import "UICKeyChainStore.h"
#import "SettingsViewController.h"

@interface LoginToPowerSchoolViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) UICKeyChainStore *keychain;
@property (strong, nonatomic) SettingsViewController *settingsViewController;
- (IBAction)editSettings:(id)sender;

@end

@implementation LoginToPowerSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    self.keychain = [[UICKeyChainStore alloc] init];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/600.3.18 (KHTML, like Gecko) Version/8.0.3 Safari/600.3.18", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://pschool.princetonk12.org/public/home.html"]]];
    
    if(self.keychain[@"username"] == nil || self.keychain[@"password"] == nil) {
        self.settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil webView:self.webView];
        [self.settingsViewController showInView:self.view shouldAnimate:YES];
    }
    else {
        [self injectInformation:[self.keychain[@"isStudent"] isEqualToString:@"YES"] username:self.keychain[@"username"] password:self.keychain[@"password"]];
    }
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.webView.delegate = self;
    return self;
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *currentURL = webView.request.URL.absoluteString;
    
    //If we are at the basic login page
    if([currentURL isEqualToString:@"https://pschool.princetonk12.org/public/home.html"]) {
                [self injectInformation:[self.keychain[@"isStudent"] isEqualToString:@"YES"] username:self.keychain[@"username"] password:self.keychain[@"password"]];
    }
    
    NSString *yourHTMLSourceCodeString = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    
    NSLog(yourHTMLSourceCodeString);

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
    NSLog(@"Finished");
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"Started loading");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editSettings:(id)sender {
    self.settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil webView:self.webView];
    [self.settingsViewController showInView:self.view shouldAnimate:YES];
}

@end
