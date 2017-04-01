//
//  FoodItem.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/30/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "FoodItem.h"

@implementation FoodItem

- (void) configureWithDict: (NSDictionary*) dict {

    self.comida = dict [@"Comida"];
    self.descripcion = dict [@"Porcion"];
    self.glucidos = [dict [@"CH"] floatValue];
    self.calorias = [dict [@"Calorias"] floatValue];
    self.fibras = [dict [@"Fibras"] floatValue];
    
    self.porcion = 120;
    
}

- (NSString*) identificationKey {
    return [NSString stringWithFormat:@"%@-%.2f-%.2f",self.comida,self.glucidos,self.fibras];
}

@end
