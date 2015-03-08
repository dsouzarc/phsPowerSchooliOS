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
#import "SettingsViewController.h"
#import "Assignment.h"
#import "ViewAllGradesViewController.h"

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
    
    NSString *html = [[NSBundle mainBundle] pathForResource:@"HTML" ofType:@"txt"];
    
    NSData *data = [NSData dataWithContentsOfFile:html];

    TFHpple *document = [[TFHpple alloc] initWithHTMLData:data];
    
    NSString *tutorialsXpathQueryString = @"//div[@id='content-main']/div/table/tbody/tr"; ///td
    NSArray *tutorialsNodes = [document searchWithXPathQuery:tutorialsXpathQueryString];
    
    NSArray *classInformation = ((TFHppleElement*)[tutorialsNodes objectAtIndex:0]).children;
    NSString *className = ((TFHppleElement*)classInformation[1]).text;
    NSString *grade = ((TFHppleElement*)classInformation[7]).text;
    
    NSMutableArray *allAssignments = [[NSMutableArray alloc] init];
    
    for (int i = 5; i < tutorialsNodes.count - 1; i++) {
        TFHppleElement *entireClass = (TFHppleElement*)[tutorialsNodes objectAtIndex:i];
        NSArray *assignmentDetails = [entireClass children];
        
        NSString *date = ((TFHppleElement*)assignmentDetails[1]).content;
        NSString *type = ((TFHppleElement*)assignmentDetails[3]).content;
        NSString *name = ((TFHppleElement*)assignmentDetails[5]).content;
        
        NSArray *score = [self parseAssignmentGrade:((TFHppleElement*)assignmentDetails[17]).content];
        
        NSString *pointsAwarded = (NSString*)score[0];
        NSString *totalPoints = (NSString*)score[1];
        
        NSString *letterGrade = ((TFHppleElement*)assignmentDetails[21]).content;
        
        Assignment *assignment = [[Assignment alloc] initWithEverything:date assignmentType:type assignmentTitle:name pointsAwarded:pointsAwarded totalPoints:totalPoints asignmentLetterGrade:letterGrade];
        
        [allAssignments addObject:assignment];
    }
    
    for(Assignment *assignment in allAssignments) {
        //NSLog(@"%@\n\n", assignment);
    }
}

- (NSArray*) parseAssignmentGrade:(NSString*)originalGrade
{
    NSArray *score = [originalGrade componentsSeparatedByString:@"/"];
    return score;
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
    
    if([currentURL isEqualToString:@"https://pschool.princetonk12.org/guardian/studentsched.html"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://pschool.princetonk12.org/guardian/home.html"]]];
    }
    
    else if([currentURL isEqualToString:@"https://pschool.princetonk12.org/guardian/home.html"]){
        ViewAllGradesViewController *viewAllGrades = [[ViewAllGradesViewController alloc] initWithNibName:@"ViewAllGradesViewController" bundle:[NSBundle mainBundle] webView:self.webView];
        
        self.view.window.rootViewController = viewAllGrades;
    }
    
    //Specific class grades
    else if([currentURL containsString:@"https://pschool.princetonk12.org/guardian/scores.html?frn="] && 1 != 1) {
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
