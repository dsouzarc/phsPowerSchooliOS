//
//  ViewAllGradesViewController.h
//  PHSPowerSchool
//
//  Created by Ryan D'souza on 3/7/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ViewController.h"

@interface ViewAllGradesViewController : ViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil webView:(UIWebView*)webView;

@end
