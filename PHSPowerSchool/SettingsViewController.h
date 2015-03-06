//
//  SettingsViewController.h
//  PHSPowerSchool
//
//  Created by Ryan D'souza on 3/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITextFieldDelegate>

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil webView:(UIWebView*)webView;

- (void) showInView:(UIView *)view shouldAnimate:(BOOL)shouldAnimate;

@end
