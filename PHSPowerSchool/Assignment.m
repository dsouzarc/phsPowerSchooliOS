//
//  Assignment.m
//  PHSPowerSchool
//
//  Created by Ryan D'souza on 3/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "Assignment.h"

@implementation Assignment

- (instancetype) initWithEverything:(NSString *)assignmentDate assignmentType:(NSString *)assignmentType
                    assignmentTitle:(NSString *)assignmentTitle pointsAwarded:(NSString*)pointsAwarded
                        totalPoints:(NSString*)totalPoints asignmentLetterGrade:(NSString *)letterGrade
{
    self = [super init];
    
    self.assignmentDate = assignmentDate;
    self.assignmentType = assignmentType;
    self.assignmentTitle = assignmentTitle;
    self.pointsAwarded = pointsAwarded;
    self.totalPoints = totalPoints;
    self.assignmentLetterGrade = letterGrade;
    
    return self;
}

- (NSString*)description
{
    NSMutableString *result = [[NSMutableString alloc] init];
    
    [result appendString:@"Assignment:\t"];
    [result appendString:self.assignmentTitle];
    
    [result appendString:[NSString stringWithFormat:@"\t%@", self.assignmentDate]];
    [result appendString:[NSString stringWithFormat:@"\t%@", self.assignmentType]];
    [result appendString:[NSString stringWithFormat:@"\t%@", self.assignmentLetterGrade]];
    [result appendString:[NSString stringWithFormat:@"\t%@/%@", self.pointsAwarded, self.totalPoints]];
    return result;
}

@end
