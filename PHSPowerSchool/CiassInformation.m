//
//  CiassInformation.m
//  PHSPowerSchool
//
//  Created by Ryan D'souza on 3/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "CiassInformation.h"

@implementation CiassInformation

- (instancetype) initWithInformation:(NSString *)letterGrade link:(NSString *)link
{
    self = [super init];
    
    if(self) {
        self.letterGrade = letterGrade;
        self.link = link;
    }
    
    return self;
}

- (NSString*) description
{
    NSMutableString *result = [[NSMutableString alloc] init];
    
    [result appendString:@"Class Information: "];
    [result appendString:self.letterGrade];
    [result appendString:@"\tLink: "];
    [result appendString:self.link];
    return result;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.letterGrade = [aDecoder decodeObjectForKey:@"letterGrade"];
    self.link = [aDecoder decodeObjectForKey:@"link"];
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.letterGrade forKey:@"letterGrade"];
    [aCoder encodeObject:self.link forKey:@"link"];
}

@end
