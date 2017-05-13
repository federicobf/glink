//
//  SlidersViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 4/23/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "SlidersViewController.h"


@interface SlidersViewController ()

@end

@implementation SlidersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float myAngle = (_relSlider.value = 1 );
    
    
    
    if(myAngle < kMaxRelacion) {
        myAngle -= kMaxRelacion;
    }
    
    if(myAngle > kMinRelacion) {
        myAngle += kMinRelacion;
        
    }
    
    
    
    // Do any additional setup after loading the view.
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
