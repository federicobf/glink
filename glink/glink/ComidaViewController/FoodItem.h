//
//  FoodItem.h
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/30/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodItem : NSObject

@property NSString* comida;
@property NSString* descripcion;
@property float porcion;
@property float glucidos;
@property float calorias;
@property float fibras;
@property float ratio;

- (void) configureWithDict: (NSDictionary*) dict;
- (NSString*) identificationKey;
@end
