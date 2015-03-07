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
#import "TFHpple.h"

#import "StudentCIass.h"
#import "CiassInformation.h"
#import "SettingsViewController.h"

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
    
    NSString *tutorialsXpathQueryString = @"//div[@id='content-main']/div/table/tbody/tr"; ///td
    NSArray *tutorialsNodes = [document searchWithXPathQuery:tutorialsXpathQueryString];
    
    NSArray *classInformation = ((TFHppleElement*)[tutorialsNodes objectAtIndex:0]).children;
    NSString *className = ((TFHppleElement*)classInformation[1]).text;
    NSString *grade = ((TFHppleElement*)classInformation[7]).text;
    
    for (int i = 5; i < tutorialsNodes.count - 1; i++) {
        TFHppleElement *entireClass = (TFHppleElement*)[tutorialsNodes objectAtIndex:i];
        NSArray *assignmentDetails = [entireClass children];
        
        for(int y = 0; y < assignmentDetails.count; y++) {
            TFHppleElement *value = (TFHppleElement*)assignmentDetails[y];
            
            if(value.content.length > 0) {
                NSLog(@"%i\t%i\t%@", i, y, value.content);
            }
        }
    }
}


- (CiassInformation*) getClassInformation:(TFHppleElement*)attributes
{
    NSString *grade = attributes.content;
    NSString *link = [NSString stringWithFormat:@"https://pschool.princetonk12.org/guardian/%@",
                      [self parseLinkFromTD:attributes.raw]];
    
    return [[CiassInformation alloc] initWithInformation:grade link:link];
}

- (NSString*) parseLinkFromTD:(NSString*)string
{
    string = [string componentsSeparatedByString:@">"][1];
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
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
    
    NSLog(@"CURRENT URL: %@", currentURL);
    
    //If we are at the basic login page
    if([currentURL isEqualToString:@"https://pschool.princetonk12.org/public/home.html"]) {
                [self injectInformation:[self.keychain[@"isStudent"] isEqualToString:@"YES"] username:self.keychain[@"username"] password:self.keychain[@"password"]];
    }
    
    else if([currentURL isEqualToString:@"https://pschool.princetonk12.org/guardian/home.html"]){
        NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
        
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        TFHpple *document = [[TFHpple alloc] initWithHTMLData:data];
        
        NSString *tutorialsXpathQueryString = @"//div[@id='quickLookup']/table/tbody/tr"; ///td
        NSArray *tutorialsNodes = [document searchWithXPathQuery:tutorialsXpathQueryString];
        
        for (int i = 3; i < tutorialsNodes.count - 9; i++) {
            
            TFHppleElement *entireClass = (TFHppleElement*)[tutorialsNodes objectAtIndex:i];
            NSArray *classDetails = entireClass.children;
            
            NSString *className = ((TFHppleElement*)classDetails[14]).content;
            
            CiassInformation *q1Information = [self getClassInformation:((TFHppleElement*)classDetails[16])];
            CiassInformation *q2Information = [self getClassInformation:((TFHppleElement*)classDetails[18])];
            CiassInformation *x1Information = [self getClassInformation:((TFHppleElement*)classDetails[20])];
            CiassInformation *q3Information = [self getClassInformation:((TFHppleElement*)classDetails[22])];
            CiassInformation *q4Information = [self getClassInformation:((TFHppleElement*)classDetails[24])];
            CiassInformation *x2Information = [self getClassInformation:((TFHppleElement*)classDetails[26])];
            
            StudentCIass *class = [[StudentCIass alloc] initWithAllInformation:className q1:q1Information q2:q2Information x1:x1Information q3:q3Information q4:q4Information x2:x2Information];
            
            [self.studentClasses addObject:class];
        }
        
        for(StudentCIass *class in self.studentClasses) {
            NSLog(class.description);
        }
        
        NSString *tempLink = ((StudentCIass*)self.studentClasses[0]).q1.link;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempLink]]];
    }
    
    //Specific class grades
    else if([currentURL containsString:@"https://pschool.princetonk12.org/guardian/scores.html?frn="]) {
        NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
        
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        TFHpple *document = [[TFHpple alloc] initWithHTMLData:data];
        
        NSString *tutorialsXpathQueryString = @"//div[@id='quickLookup']/table/tbody/tr"; ///td
        NSArray *tutorialsNodes = [document searchWithXPathQuery:tutorialsXpathQueryString];
        
        for (int i = 3; i < tutorialsNodes.count - 9; i++) {
            
            TFHppleElement *entireClass = (TFHppleElement*)[tutorialsNodes objectAtIndex:i];
            NSArray *classDetails = entireClass.children;
            
            NSString *className = ((TFHppleElement*)classDetails[14]).content;
        }
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

- (IBAction)editSettings:(id)sender {
    self.settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil webView:self.webView];
    [self.settingsViewController showInView:self.view shouldAnimate:YES];
}

@end
