//
//  HealthDTO.h
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/17/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HealthDTO : NSObject

@property CGFloat carbohidratos;
@property CGFloat glucemia;
@property CGFloat insulina;
@property NSDate*  date;

- (NSDate*) getSimpleDate;

@end
