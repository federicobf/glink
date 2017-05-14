//
//  SlidersViewController.h
//  glink
//
//  Created by Federico Bustos Fierro on 4/23/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthManager.h"


@interface SlidersViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *relSlider;
@property (weak, nonatomic) IBOutlet UISlider *objetivoSlider;
@property (weak, nonatomic) IBOutlet UILabel *sensibilidadLabel;
@property (weak, nonatomic) IBOutlet UISlider *sensibilidadSlider;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *objetivoLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UILabel *relLabel;
@property (nonatomic, readonly) BOOL isModal;
@end
