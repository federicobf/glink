//
//  NewItemViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/17/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "NewItemViewController.h"
#import "HealthManager.h"

@interface NewItemViewController () <UITextFieldDelegate>

@end

@implementation NewItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.glucemiaTextfield.tag = 2;
    self.glucemiaTextfield.text = @"0";
    self.glucemiaTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    self.glucemiaTextfield.inputAccessoryView = [self toolbarWithTag:2];
    self.glucemiaTextfield.delegate = self;
    
    self.chTextfield.tag = 1;
    self.chTextfield.text = @"0";
    self.chTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    self.chTextfield.inputAccessoryView = [self toolbarWithTag:1];
    self.chTextfield.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    BOOL continuar = newLength <= 6;
    
    if (continuar) {
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([newString hasPrefix:@"0"]) {
            newString = [newString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString: @""];
        }
        
        if ([newString isEqualToString: @""]) {
            newString = @"0";
            textField.text = @"0";
        }
        
        
        if (textField.tag == 1) {
            self.chTextfield.text  = newString;
        }
        if (textField.tag == 2) {
            self.glucemiaTextfield.text  = newString;
        }
    }
    
    return NO;
}

- (UIToolbar*) toolbarWithTag: (NSInteger) toolbarNumber {
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"Borrar" style:UIBarButtonItemStylePlain target:self action:@selector(borrarNumberPad:)];
    cancel.tag = toolbarNumber;
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *ok = [[UIBarButtonItem alloc]initWithTitle:@"Aceptar" style:UIBarButtonItemStylePlain target:self action:@selector(returnNumberPad:)];
    ok.tag = toolbarNumber;
    numberToolbar.items = [NSArray arrayWithObjects:cancel,flex, ok, nil];
    [numberToolbar sizeToFit];
    return numberToolbar;
}

-(void)borrarNumberPad: (UIBarButtonItem*) sender
{
    if (sender.tag == 1) {
        self.chTextfield.text = @"0";
    }
    
    if (sender.tag == 2) {
        self.glucemiaTextfield.text = @"0";
    }
}

-(void)returnNumberPad: (UIBarButtonItem*) sender
{
    [self.chTextfield resignFirstResponder];
    [self.glucemiaTextfield resignFirstResponder];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}


- (IBAction)continuar:(id)sender {
    CGFloat chValue = self.chTextfield.text.floatValue;
    CGFloat glucemiaValue = self.glucemiaTextfield.text.floatValue;
    
    
    if (chValue <= kMinCH || chValue > kMaxCH) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fuera del Límite" message:[NSString stringWithFormat:@"Usted ha ingresado un valor que está fuera de los límites permitidos: \n Carbohidratos Mínimo: %.2f \n Carbohidratos Máximo: %.2f ", kMinCH, kMaxCH] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
        [alert show];
        return;
    }
    
    if (glucemiaValue <= kMinGlucemia || glucemiaValue > kMaxGlucemia) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fuera del Límite" message:[NSString stringWithFormat:@"Usted ha ingresado un valor que está fuera de los límites permitidos: \n Glucemia Mínimo: %.2f \n Glucemia Máximo: %.2f ", kMinGlucemia, kMaxGlucemia] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
        [alert show];
        return;
    }
    
    HealthDTO* dto = [HealthDTO new];
    dto.carbohidratos = chValue;
    dto.glucemia = glucemiaValue;
    dto.insulina = 0;
    dto.date = self.datePicker.date;
    
    [[HealthManager sharedInstance] storeNewItem:dto];
    [self close:nil];

}



- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
