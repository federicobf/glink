//
//  SlidersViewController.h
//  glink
//
//  Created by Federico Bustos Fierro on 4/23/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidersViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *relSlider;
@property (weak, nonatomic) IBOutlet UISlider *objetivoSlider;
@property (weak, nonatomic) IBOutlet UISlider *sensibilidadSlider;

@end
