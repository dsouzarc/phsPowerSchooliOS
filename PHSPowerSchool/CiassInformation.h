//
//  CiassInformation.h
//  PHSPowerSchool
//
//  Created by Ryan D'souza on 3/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CiassInformation : NSObject

@property (strong, nonatomic) NSString *letterGrade;
@property (strong, nonatomic) NSString *link;

- (instancetype) initWithInformation:(NSString*)letterGrade link:(NSString*)link;

- (NSString*) description;

@end
