//
//  HealthDayDTO.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/17/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "HealthDayDTO.h"
#import "PureLayout.h"

@implementation HealthDayDTO

- (id) init {

    self = [super init];
    
    if (self) {
    
        self.healthItems = [NSMutableArray new];
    }

    return self;

}

- (NSString*) description {
    
    
    return [NSString stringWithFormat:@"My Date? %@ /n items: %lu", self.date, self.healthItems.count];
    
}


@end
