//
//  StudentCIass.h
//  PHSPowerSchool
//
//  Created by Ryan D'souza on 3/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CiassInformation.h"

@interface StudentCIass : NSObject<NSCoding>

@property (nonatomic, strong) NSString *className;

@property (nonatomic, strong) CiassInformation *q1;
@property (nonatomic, strong) CiassInformation *q2;
@property (nonatomic, strong) CiassInformation *x1;

@property (nonatomic, strong) CiassInformation *q3;
@property (nonatomic, strong) CiassInformation *q4;
@property (nonatomic, strong) CiassInformation *x2;

- (instancetype) initWithClassName:(NSString*)className;
- (instancetype) initWithAllInformation:(NSString*)className
                                     q1:(CiassInformation*)q1
                                     q2:(CiassInformation*)q2
                                     x1:(CiassInformation*)x1
                                     q3:(CiassInformation*)q3
                                     q4:(CiassInformation*)q4
                                     x2:(CiassInformation*)x2;

- (NSString*) description;

@end
