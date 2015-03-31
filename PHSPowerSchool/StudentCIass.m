//
//  StudentCIass.m
//  PHSPowerSchool
//
//  Created by Ryan D'souza on 3/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "StudentCIass.h"

@implementation StudentCIass

- (instancetype) initWithAllInformation:(NSString *)className
                                     q1:(CiassInformation *)q1 q2:(CiassInformation *)q2
                                     x1:(CiassInformation *)x1 q3:(CiassInformation *)q3
                                     q4:(CiassInformation *)q4 x2:(CiassInformation *)x2
{
    self = [super init];
    
    if(self) {
        self.className = className;
        self.q1 = q1;
        self.q2 = q2;
        self.x1 = x1;
        self.q3 = q3;
        self.q4 = q4;
        self.x2 = x2;
    }
    return self;
}

- (instancetype) initWithClassName:(NSString *)className
{
    self = [self initWithAllInformation:className q1:nil q2:nil x1:nil q3:nil q4:nil x2:nil];
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.className forKey:@"className"];
    
    [aCoder encodeObject:self.q1 forKey:@"q1"];
    [aCoder encodeObject:self.q2 forKey:@"q2"];
    [aCoder encodeObject:self.q3 forKey:@"q3"];
    [aCoder encodeObject:self.q4 forKey:@"q4"];
    
    [aCoder encodeObject:self.x1 forKey:@"x1"];
    [aCoder encodeObject:self.x2 forKey:@"x2"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.className = [aDecoder decodeObjectForKey:@"className"];
    
    self.q1 = [aDecoder decodeObjectForKey:@"q1"];
    self.q2 = [aDecoder decodeObjectForKey:@"q2"];
    self.q3 = [aDecoder decodeObjectForKey:@"q3"];
    self.q4 = [aDecoder decodeObjectForKey:@"q4"];
    
    self.x1 = [aDecoder decodeObjectForKey:@"x1"];
    self.x2 = [aDecoder decodeObjectForKey:@"x2"];
    
    return self;
}

- (NSString*) description
{
    NSMutableString *result = [[NSMutableString alloc] init];
    
    [result appendString:self.className];
    [result appendFormat:@"\t%@", self.q1];
    [result appendFormat:@"\t%@", self.q2];
    [result appendFormat:@"\t%@", self.x1];
    [result appendFormat:@"\t%@", self.q3];
    [result appendFormat:@"\t%@", self.q4];
    [result appendFormat:@"\t%@", self.x2];
    return result;
}

@end
