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

@end
