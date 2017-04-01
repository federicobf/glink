//
//  FoodTableViewCell.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/30/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "FoodTableViewCell.h"

@implementation FoodTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.leftImage.layer.cornerRadius = 30;
}

- (void) setUpWithFoodItem: (FoodItem*) foodItem {
    self.foodItem = foodItem;
    self.comidaLbl.text =  [NSString stringWithFormat:@" %@", foodItem.comida];
    self.descripcionLbl.text = foodItem.descripcion;
    self.fibrasLbl.text = [NSString stringWithFormat:@"Fibras: %ig", (int) foodItem.fibras];
    self.glucidosLbl.text = [NSString stringWithFormat:@"Glúcidos: %ig", (int) foodItem.glucidos];
    self.caloriasLbl.text = [NSString stringWithFormat:@"Calorías: %ikcal", (int) foodItem.calorias];
}
- (IBAction)porcionPlus:(id)sender {
    NSInteger value = [self.amountTextfield.text integerValue];
    if (value==99) {
        return;
    }
    value++;
    self.amountTextfield.text = [NSString stringWithFormat:@"%lu", value];
    
}
- (IBAction)porcionLess:(id)sender {
    NSInteger value = [self.amountTextfield.text integerValue];
    if (value==0) {
        return;
    }
    
    value--;
    self.amountTextfield.text = [NSString stringWithFormat:@"%lu", value];
}

@end
