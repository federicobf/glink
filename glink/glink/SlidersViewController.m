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
    self.relSlider.value = 0;
    NSString *relationText = [NSString stringWithFormat:@"%.0f", kMinRelacion];
    self.relLabel.text = relationText;
}

- (IBAction)relationSliderChanged:(id)sender {
    //UPDATE LABEL WITH SLIDER
    float sliderValue = self.relSlider.value;
    float relationValue = sliderValue * (kMaxRelacion - kMinRelacion) + kMinRelacion;
    //esto es igual a hacer: relationValue = sliderValue * 29 + 1
    NSString *relationText = [NSString stringWithFormat:@"%.0f", relationValue];
    self.relLabel.text = relationText;
    



    
    
    
    self.objetivoSlider.value = 0;
    NSString *targetText = [ NSString stringWithFormat:@"%0f@", kMinTarget];
    _objetivoLabel.text =targetText;
    
}

- (IBAction)targetSliderChanged:(id)sender {
    
    float sliderValue = self.objetivoSlider.value;
    float targetValue = sliderValue * (kMaxTarget - kMinTarget) + kMinTarget;
 
    
    NSString *targetText = [NSString stringWithFormat:@"%.0f", targetValue];
    self.objetivoLabel.text = targetText;
    


    self.sensibilidadSlider.value = 0;
    NSString *sensibilidadText = [[NSString stringWithFormat:@"%0f@", kMinSensibilidad]

                                  
                                  
- (IBAction)sensibilidadSliderChanged:(id)sender {

    float sliderValue = self.sensibilidadSlider.value;
    float targetValue = sliderValue * (kMaxSensibilidad - kMinSensibilidad) + kMinSensibilidad;
    
    
    NSString *targetText = [NSString stringWithFormat:@"%.0f", sensibilidadvalue];
    self.sensibilidadLabel.text = sensibilidadText





                                   }

@end
