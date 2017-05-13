//
//  SlidersViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 4/23/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "SlidersViewController.h"


@interface SlidersViewController ()
@property (weak, nonatomic) IBOutlet UILabel *relLabel;

@end

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
