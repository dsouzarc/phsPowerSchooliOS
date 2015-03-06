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
#import "TFHpple.h"

@interface LoginToPowerSchoolViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) UICKeyChainStore *keychain;
@property (strong, nonatomic) SettingsViewController *settingsViewController;

@property (strong, nonatomic) NSMutableArray *studentClasses;

- (IBAction)editSettings:(id)sender;

@end

@implementation LoginToPowerSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    self.keychain = [[UICKeyChainStore alloc] init];
    self.studentClasses = [[NSMutableArray alloc] init];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/600.3.18 (KHTML, like Gecko) Version/8.0.3 Safari/600.3.18", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://pschool.princetonk12.org/public/home.html"]]];
    
    if(self.keychain[@"username"] == nil || self.keychain[@"password"] == nil) {
        self.settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil webView:self.webView];
        [self.settingsViewController showInView:self.view shouldAnimate:YES];
    }
    else {
        [self injectInformation:[self.keychain[@"isStudent"] isEqualToString:@"YES"] username:self.keychain[@"username"] password:self.keychain[@"password"]];
    }
    
    NSString *html = [[NSBundle mainBundle] pathForResource:@"HTML" ofType:@"txt"];
    
    NSData *data = [NSData dataWithContentsOfFile:html];
    
    TFHpple *document = [[TFHpple alloc] initWithHTMLData:data];
    
    NSString *tutorialsXpathQueryString = @"//div[@id='quickLookup']/table/tbody/tr"; ///td
    NSArray *tutorialsNodes = [document searchWithXPathQuery:tutorialsXpathQueryString];
    
    
    for (int i = 3; i < tutorialsNodes.count - 9; i++) {
        TFHppleElement *entireClass = (TFHppleElement*)[tutorialsNodes objectAtIndex:i];
        
        NSArray *classDetails = entireClass.children;
        
        for(int y = 0; y < classDetails.count; y++) {
            NSLog(@"%i\t%@", y, ((TFHppleElement*)classDetails[y]).raw);
        }
        
        NSString *className = ((TFHppleElement*)classDetails[14]).content;
        
        TFHppleElement *q1Information = ((TFHppleElement*)classDetails[16]);
        
        NSString *q1Grade = q1Information.content;
        NSString *q1Link = [self parseLinkFromTD:q1Information.raw];
    }
    
    
        // 7
        //tutorial.url = [element objectForKey:@"href"];
}

- (NSString*) parseLinkFromTD:(NSString*)string
{
    string = [string componentsSeparatedByString:@">"][1];
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"<a href=" withString:@""];
    return string;
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
    
    else {
    
        
        
    }

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
