//
//  SuccessViewController.m
//  glink
//
//  Created by Federicuelo on 25/4/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "SuccessViewController.h"
#import "MBProgressHUD.h"
#import "HealthManager.h"

@interface SuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (nonatomic, strong) UIWindow *window;

@end

@implementation SuccessViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.window = [UIApplication sharedApplication].keyWindow;
    self.overButton.layer.cornerRadius = 23;
    self.overButton.layer.masksToBounds = YES;
    self.value.text = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];

    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.label.text = @"Calculando";
    hud.contentColor = [UIColor blackColor];
    
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleBlur;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    self.value.text = [NSString stringWithFormat:@"%.2f", [[HealthManager sharedInstance] calculoFinalBolo]];
    [MBProgressHUD hideHUDForView:self.window animated:YES];

}

- (IBAction)finalize:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
