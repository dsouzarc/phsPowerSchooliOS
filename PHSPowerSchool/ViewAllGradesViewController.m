//
//  ViewAllGradesViewController.m
//  PHSPowerSchool
//
//  Created by Ryan D'souza on 3/7/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ViewAllGradesViewController.h"
#import "CiassInformation.h"
#import "StudentCIass.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
@interface ViewAllGradesViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSMutableArray *studentClasses;

@end

@implementation ViewAllGradesViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil webView:(UIWebView *)webView
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.webView = webView;
    self.studentClasses = [[NSMutableArray alloc] init];
    
    [self updateClassGrades];
    
    return self;
}

- (void)updateClassGrades
{
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

@end
