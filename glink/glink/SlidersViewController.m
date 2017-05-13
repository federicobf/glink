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
    NSString *relationText = [NSString stringWithFormat:@"%.2f", kMinRelacion];
    self.relLabel.text = relationText;
}

- (IBAction)relationSliderChanged:(id)sender {
    //UPDATE LABEL WITH SLIDER
    float sliderValue = self.relSlider.value;
    float relationValue = sliderValue * (kMaxRelacion - kMinRelacion) + kMinRelacion;
    //esto es igual a hacer: relationValue = sliderValue * 29 + 1
    NSString *relationText = [NSString stringWithFormat:@"%.2f", relationValue];
    self.relLabel.text = relationText;
}

@end
