//
//  StartViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 5/14/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController


- (IBAction)tickon:(id)sender {
    
    self.untickImage.image = [UIImage imageNamed:@"tickon"];
    
    if _untickImage.image
        = [UIImage imagen named:@"tickoff"]
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    


    
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
