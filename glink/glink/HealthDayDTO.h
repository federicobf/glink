//
//  HealthDayDTO.h
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/17/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthDTO.h"

@interface HealthDayDTO : NSObject

@property NSDate* date;
@property NSMutableArray* healthItems;

@end
