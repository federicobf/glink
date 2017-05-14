//
//  SlidersViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 4/23/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "SlidersViewController.h"

@implementation SlidersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftButton.layer.cornerRadius = 23;
    self.leftButton.layer.masksToBounds = YES;
    
    self.rightButton.layer.cornerRadius = 23;
    self.rightButton.layer.masksToBounds = YES;
    
   //SETUP INICIAL
    self.scrollview.delaysContentTouches = NO;

    NSString *relationText = [NSString stringWithFormat:@"%.0f", kMinRelacion];
    self.relLabel.text = relationText;
    self.relSlider.value = 0;
    
    NSString *targetText = [NSString stringWithFormat:@"%.0f", kMinTarget];
    self.objetivoLabel.text = targetText;
    self.objetivoSlider.value = 0;
    
    NSString *sensibilidadText = [NSString stringWithFormat:@"%.0f", kMinSensibilidad];
    self.sensibilidadLabel.text = sensibilidadText;
    self.sensibilidadSlider.value = 0;
}

- (IBAction)relationSliderChanged:(id)sender {
    //UPDATE LABEL WITH SLIDER
    float sliderValue = self.relSlider.value;
    float relationValue = sliderValue * (kMaxRelacion - kMinRelacion) + kMinRelacion;

    NSString *relationText = [NSString stringWithFormat:@"%.0f", relationValue];
    self.relLabel.text = relationText;
}

- (IBAction)targetSliderChanged:(id)sender {
    
    float sliderValue = self.objetivoSlider.value;
    float targetValue = sliderValue * (kMaxTarget - kMinTarget) + kMinTarget;
 
    
    NSString *targetText = [NSString stringWithFormat:@"%.0f", targetValue];
    self.objetivoLabel.text = targetText;
    
}
                                  
- (IBAction)sensibilidadSliderChanged:(id)sender {

    float sliderValue = self.sensibilidadSlider.value;
    float sensibilidadvalue = sliderValue * (kMaxSensibilidad - kMinSensibilidad) + kMinSensibilidad;

    
    NSString *sensibilidadText = [NSString stringWithFormat:@"%.0f", sensibilidadvalue];
    self.sensibilidadLabel.text = sensibilidadText;
    
}

- (IBAction)continuar:(id)sender {
    [HealthManager sharedInstance].relacionch = self.relLabel.text.floatValue;
    [HealthManager sharedInstance].target = self.objetivoLabel.text.floatValue;
    [HealthManager sharedInstance].sensibilidad = self.sensibilidadLabel.text.floatValue;
    [self performSegueWithIdentifier:@"nextStep" sender:nil];
}

- (IBAction)backAction:(id)sender
{
        [self.navigationController popViewControllerAnimated:YES];
}

@end
