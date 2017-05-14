//
//  ReviewViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 5/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "ReviewViewController.h"
#import "HealthManager.h"
#import "CarbsViewController.h"
#import "GlucemiaViewController.h"
#import "SlidersViewController.h"

@interface ReviewViewController ()
@property (weak, nonatomic) IBOutlet UILabel *relacion;
@property (weak, nonatomic) IBOutlet UILabel *sensibilidad;
@property (weak, nonatomic) IBOutlet UILabel *target;
@property (weak, nonatomic) IBOutlet UILabel *carbs;
@property (weak, nonatomic) IBOutlet UILabel *glucemia;
@property (weak, nonatomic) IBOutlet UISwitch *switchItem;
@property CGFloat reductionFactor;

@end

@implementation ReviewViewController

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reductionFactor = 1;
    self.carbs.text = [NSString stringWithFormat:@"%i", (int) [HealthManager sharedInstance].cantidadch];
    self.glucemia.text = [NSString stringWithFormat:@"%i", (int) [HealthManager sharedInstance].glucemia];
    self.relacion.text = [NSString stringWithFormat:@"%i", (int) [HealthManager sharedInstance].relacionch];
    self.sensibilidad.text = [NSString stringWithFormat:@"%i", (int) [HealthManager sharedInstance].sensibilidad];
    self.target.text = [NSString stringWithFormat:@"%i", (int) [HealthManager sharedInstance].target];
}

- (IBAction)changeGlucemia:(id)sender {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[GlucemiaViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}


- (IBAction)changeCarbs:(id)sender {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[CarbsViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}
- (IBAction)changeOtherInfo:(id)sender {
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SlidersViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}
- (IBAction)switchChanged:(id)sender {
    self.reductionFactor = 1;
    if (self.switchItem.on) {
        [self ejercicioFlow];
    }
}


- (void) ejercicioFlow {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Dosis Parcial"
                                  message:@"Si tienes pensado realizar ejercicio debes aplicarte una dosis parcial acorde al porcentaje (%) de reducción recomendado por tu médico."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSNumber *value in @[@10,@20,@25,@30,@40,@50,@60,@70,@80,@90]) {
        UIAlertAction* action = [UIAlertAction
                                 actionWithTitle:[NSString stringWithFormat:@"%.f%%", value.floatValue]
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     self.reductionFactor = (1 - value.integerValue/100.f);

                                     
                                 }];
        [alert addAction:action];
    }
    
    UIAlertAction* cancelar = [UIAlertAction
                               actionWithTitle:@"Cancelar"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action)
                               {
                                   self.reductionFactor = 1;
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:cancelar];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)nextStep:(id)sender {
    [HealthManager sharedInstance].reductionFactor = self.reductionFactor;
    [self performSegueWithIdentifier:@"nextStep" sender:nil];
}

@end
