//
//  FoodTableViewCell.h
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/30/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodItem.h"

@interface FoodTableViewCell : UITableViewCell

@property FoodItem* foodItem;
@property (weak, nonatomic) IBOutlet UILabel *comidaLbl;
@property (weak, nonatomic) IBOutlet UILabel *fibrasLbl;
@property (weak, nonatomic) IBOutlet UILabel *glucidosLbl;
@property (weak, nonatomic) IBOutlet UILabel *caloriasLbl;
@property (weak, nonatomic) IBOutlet UILabel *descripcionLbl;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlus;
@property (weak, nonatomic) IBOutlet UIButton *buttonLess;
@property (weak, nonatomic) IBOutlet UITextField *amountTextfield;

- (void) setUpWithFoodItem: (FoodItem*) foodItem;

@end
