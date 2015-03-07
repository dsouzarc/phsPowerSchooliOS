//
//  Assignment.h
//  PHSPowerSchool
//
//  Created by Ryan D'souza on 3/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Assignment : NSObject

@property (nonatomic, strong) NSString *assignmentDate;
@property (nonatomic, strong) NSString *assignmentType;
@property (nonatomic, strong) NSString *assignmentTitle;
@property (nonatomic) NSString *pointsAwarded;
@property (nonatomic) NSString *totalPoints;
@property (nonatomic, strong) NSString *assignmentLetterGrade;

- (instancetype) initWithEverything:(NSString*)assignmentDate
                     assignmentType:(NSString*)assignmentType
                    assignmentTitle:(NSString*)assignmentTitle
                      pointsAwarded:(NSString*)pointsAwarded
                        totalPoints:(NSString*)totalPoints
               asignmentLetterGrade:(NSString*)letterGrade;

- (NSString*)description;

@end
