//
//  CarbsViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 5/7/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "CarbsViewController.h"
#import "HealthManager.h"

@interface CarbsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backbutton;
@property (weak, nonatomic) IBOutlet UITextView *descriptorSection;

@end

@implementation CarbsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.backbutton.layer.cornerRadius = 23;
    self.backbutton.layer.masksToBounds = YES;
    if (self.initialText) {
        self.descriptorSection.text = self.initialText;
    } else {
        [self.descriptorSection removeFromSuperview];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.initialValue) {
        self.amountLabel.text = [NSString stringWithFormat:@"%.0f", self.initialValue];
        float distanciaX =  self.initialValue*3.0f - [UIScreen mainScreen].bounds.size.width/2;
        CGRect size = CGRectMake(distanciaX, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        [self.scrollView scrollRectToVisible:size animated:YES];
    }
}

- (IBAction)continue:(id)sender
{
    
    CGFloat chValue = self.amountLabel.text.floatValue;
    if (chValue > kWarnCH && chValue < kMaxCH) {
        [self hipercarbsFlow];
        return;
    }
    
    //ERROR
    if (chValue <= kMinCH || chValue >= kMaxCH) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fuera del Límite" message:[NSString stringWithFormat:@"Usted ha ingresado un valor que está fuera de los límites permitidos: \n Carbohidratos Mínimo: %.2f \n Carbohidratos Máximo: %.2f ", kMinCH, kMaxCH] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
        [alert show];
        return;
    }
    
    

    [HealthManager sharedInstance].cantidadch = chValue;    
    [self performSegueWithIdentifier:@"nextStep" sender:nil];
}

- (void) hipercarbsFlow {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Advertencia"
                                  message:@"Usted ha indicado un valor de carbohidratos demasiado alto. Recuerde que debe ingresar solo el peso de los carbohidratos a consumir y no el peso del total de la comida."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction
                             actionWithTitle:@"He revisado este dato"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 CGFloat chValue = self.amountLabel.text.floatValue;
                                 [HealthManager sharedInstance].cantidadch = chValue;
                                 [self performSegueWithIdentifier:@"nextStep" sender:nil];
                                 
                             }];
    [alert addAction:action];
    
    UIAlertAction* cancelar = [UIAlertAction
                               actionWithTitle:@"Modificar"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:cancelar];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
