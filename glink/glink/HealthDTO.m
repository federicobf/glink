//
//  HealthDTO.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/17/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "HealthDTO.h"

@implementation HealthDTO


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeFloat:self.carbohidratos forKey:@"CHValue"];
    [coder encodeFloat:self.glucemia forKey:@"GlucemiaValue"];
    [coder encodeFloat:self.insulina forKey:@"InsulinaValue"];
    [coder encodeObject:self.date forKey:@"Date"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.carbohidratos = [coder decodeFloatForKey:@"CHValue"];
        self.glucemia = [coder decodeFloatForKey:@"GlucemiaValue"];
        self.insulina = [coder decodeFloatForKey:@"InsulinaValue"];
        self.date = [coder decodeObjectForKey:@"Date"];
    }
    return self;
}

- (NSString*) description {


    return [NSString stringWithFormat:@"Date: %@ SDate: %@ CH: %f G: %f I: %f", self.date, [self getSimpleDate], self.carbohidratos, self.glucemia, self.insulina];

}

- (NSDate*) getSimpleDate {

    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.date];
    NSDate* date = [calendar dateFromComponents: components];
    
    return date;
}

@end
