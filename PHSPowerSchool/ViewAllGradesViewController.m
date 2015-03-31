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
#import "QuarterCollectionViewCell.h"

@interface ViewAllGradesViewController ()

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

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil webView:nil];
    return self;
}

- (void)updateClassGrades
{
    /*
     FOR TESTING
     NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *document = [[TFHpple alloc] initWithHTMLData:data];
    
    NSString *tutorialsXpathQueryString = @"//div[@id='quickLookup']/table/tbody/tr"; ///td
    NSArray *tutorialsNodes = [document searchWithXPathQuery:tutorialsXpathQueryString];
    
    if(tutorialsNodes == nil || tutorialsNodes.count <= 3) {
        return;
    }
    
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
    } */
    
    [self.studentClasses removeAllObjects];
    
    [self loadData];
    
    for(StudentCIass *class in self.studentClasses) {
        NSLog(class.description);
    }
    
    //[self saveData];
    //NSLog(@"DATA SAVED");
    
    //NSString *tempLink = ((StudentCIass*)self.studentClasses[0]).q1.link;
    //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempLink]]];
}

- (void) loadData
{
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedArray = [currentDefaults objectForKey:@"StudentClasses"];
    if (savedArray != nil)
    {
        NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        if (oldArray != nil) {
            self.studentClasses = [[NSMutableArray alloc] initWithArray:oldArray];
            
            NSLog(@"SUCCESS!");
            
            for(StudentCIass *class in self.studentClasses) {
                NSLog(class.description);
            }
            
        } else {
            self.studentClasses = [[NSMutableArray alloc] init];
        }
    }
}

- (void) saveData
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.studentClasses] forKey:@"StudentClasses"];
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

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //Number of classes + 1 for field info 
    return self.studentClasses.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //Number of fields per class
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QuarterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QuarterCollectionViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"T1";
    [cell.textLabel sizeToFit];
    
    UILabel *temp = (UILabel*)[cell viewWithTag:100];
    temp.text = @"Success!";
    
    cell.textLabel.textColor = [UIColor yellowColor];
    cell.backgroundColor=[UIColor greenColor];
    return cell;
}

/*- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger SMEPGiPadViewControllerCellWidth = 70; //self.collectionView.collectionViewLay
    
    NSInteger numberOfCells = self.view.frame.size.width / SMEPGiPadViewControllerCellWidth;
    NSInteger edgeInsets = (self.view.frame.size.width - (6 * SMEPGiPadViewControllerCellWidth)) / (numberOfCells + 1);
    
    return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets);
    //return UIEdgeInsetsMake(0, 100, 0, 0);
}*/



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    flowLayout.itemSize = CGSizeMake(70, 70);
    
    //[self.collectionView registerClass:[QuarterCollectionViewCell class] forCellWithReuseIdentifier:@"QuarterCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"QuarterCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"QuarterCollectionViewCell"];
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewLayout = flowLayout;
    
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
