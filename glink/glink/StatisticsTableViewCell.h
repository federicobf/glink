//
//  StatisticsTableViewCell.h
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/17/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDayDTO.h"

@interface StatisticsTableViewCell : UIView
@property HealthDayDTO* day;
@property NSMutableArray* drawPoints;
@property NSInteger type;
- (void) configureWithHealthDay: (HealthDayDTO*) day;
@end
