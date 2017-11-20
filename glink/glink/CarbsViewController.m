//
//  CarbsViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 5/7/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "CarbsViewController.h"
#import "HealthManager.h"
#import "glink-Swift.h"

@interface CarbsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backbutton;
@property (weak, nonatomic) IBOutlet UITextView *descriptorSection;
@property (weak, nonatomic) IBOutlet UIImageView *stepcounter;

@end

@implementation CarbsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.backbutton.layer.cornerRadius = 23;
    self.backbutton.layer.masksToBounds = YES;
    if (self.initialText) {
        self.descriptorSection.text = self.initialText;
    } else {
        [self.descriptorSection removeFromSuperview];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self stepCounterUpdate];
    if (self.firstUse)
    self.amountLabel.text = [NSString stringWithFormat:@"0"];
}

- (void) stepCounterUpdate
{
    CGFloat relacionValue = [[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat: @"relationValue-1"]];
    if (relacionValue>0) {
        self.stepcounter.image = [UIImage imageNamed:@"step2-bis"];
    } else {
        self.stepcounter.image = [UIImage imageNamed:@"step2"];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        if (self.firstUse) {
    CGFloat autovalue = self.initialValue? : 0;
    self.amountLabel.text = [NSString stringWithFormat:@"%.0f", autovalue];
    float distanciaX =  self.initialValue*3.0f - [UIScreen mainScreen].bounds.size.width;
    CGRect size = CGRectMake(distanciaX, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    [self.scrollView scrollRectToVisible:size animated:(autovalue != 0)];
    [self performSelector:@selector(autoScroll) withObject:nil afterDelay:.2f];
            self.firstUse = NO;
        }
}

- (void) autoScroll
{
    if(self.descriptorSection.text.length > 0 ) {
        NSRange bottom = NSMakeRange(self.descriptorSection.text.length -1, 1);
        [self.descriptorSection scrollRangeToVisible:bottom];
    }
}

- (void) doTextColorCheck
{
    CGFloat carbsValue = self.amountLabel.text.floatValue;
    
    if (carbsValue <= kMinCH || carbsValue >= kWarnCH) {
        self.amountLabel.textColor = [UIColor colorWithRed:1 green:.2f blue:.2f alpha:.5f];
    } else {
        self.amountLabel.textColor  = [UIColor colorWithRed:58/255.f green:62/255.f blue:65/255.f alpha:1];
    }
}

- (IBAction)continue:(id)sender
{
    
    CGFloat chValue = self.amountLabel.text.floatValue;
    if (chValue > kWarnCH && chValue < kMaxCH) {
        [self hipercarbsFlow];
        return;
    }
    
    //ERROR
    if (chValue <= kMinCH || chValue >= kMaxCH) {
        ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Fuera del Límite" message:[NSString stringWithFormat:@"Usted ha ingresado un valor que está fuera de los límites permitidos: \n Carbohidratos Mínimo: %.2f \n Carbohidratos Máximo: %.2f ", kMinCH, kMaxCH] closeButtonText:@"De acuerdo" closeButtonHandler:^(ZAlertView * _Nonnull alertview) {
            [alertview dismissAlertView];
        }];
        [alert show];
        return;
    }
    
    

    [HealthManager sharedInstance].cantidadch = chValue;    
    [self continuar];
}

- (void) hipercarbsFlow {
    

    
    
    UIColor *bgColor = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *textColor = [UIColor whiteColor];
    
    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Advertencia" message:@"Usted ha indicado un valor de carbohidratos demasiado alto. Recuerde que debe ingresar solo el peso de los carbohidratos a consumir y no el peso del total de la comida." alertType:AlertTypeMultipleChoice];
    
    [alert addButton:@"He revisado este dato" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        CGFloat chValue = self.amountLabel.text.floatValue;
        [HealthManager sharedInstance].cantidadch = chValue;
        [self continuar];
    }];
    
    [alert addButton:@"Modificar" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
    }];
    
    [alert show];
    
}

- (void) continuar
{
    CGFloat relacionValue = [[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat: @"relationValue-1"]];
    if (relacionValue>0) {
        [self performSegueWithIdentifier:@"reviewFlow" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"nextStep" sender:nil];
    }
    

}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
