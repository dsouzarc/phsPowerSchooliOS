//
//  QuarterCollectionViewCell.m
//  PHSPowerSchool
//
//  Created by Ryan D'souza on 3/7/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "QuarterCollectionViewCell.h"

@implementation QuarterCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    
    self.textLabel = [[UILabel alloc] init];
    
    
    self.textLabel.text = @"Hi";
    [self.contentView addSubview:self.textLabel];
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.textLabel = [[UILabel alloc] init];
    
    self.textLabel.text = @"From nib";
    [self.contentView addSubview:self.textLabel];
}


@end
