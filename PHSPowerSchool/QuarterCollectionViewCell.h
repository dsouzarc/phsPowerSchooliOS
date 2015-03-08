//
//  QuarterCollectionViewCell.h
//  PHSPowerSchool
//
//  Created by Ryan D'souza on 3/7/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuarterCollectionViewCell : UICollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame;

@property (strong, nonatomic) IBOutlet UILabel *textLabel;


@end
