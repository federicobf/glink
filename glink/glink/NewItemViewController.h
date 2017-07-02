//
//  NewItemViewController.h
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/17/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *chTextfield;
@property (weak, nonatomic) IBOutlet UITextField *glucemiaTextfield;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
