//
//  GlucemiaViewController.m
//  glink
//
//  Created by Federicuelo on 15/4/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "GlucemiaViewController.h"
#import "HealthManager.h"
#import "glink-Swift.h"

@interface GlucemiaViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *stepcounter;

@end

@implementation GlucemiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextButton.layer.cornerRadius = 23;
    self.nextButton.layer.masksToBounds = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width/2, 0, [UIScreen mainScreen].bounds.size.width/2);
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ftuSeen"];
}

- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.strippedView.alpha = 0;
    [self doTextColorCheck];
    [self stepCounterUpdate];
}

- (void) stepCounterUpdate
{
    CGFloat relacionValue = [[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat: @"relationValue-%lu", 1]];
    if (relacionValue>0) {
        self.stepcounter.image = [UIImage imageNamed:@"step1-bis"];
    } else {
        self.stepcounter.image = [UIImage imageNamed:@"step1"];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.strippedView drawLines];
    self.strippedView.alpha = 0;
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.strippedView.alpha = 1;
    } completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float distanciaX = scrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width/2;
    float glucemia = distanciaX / 3.f;
    
    if (glucemia < 0) {
        glucemia = 0;
    }
    
    if (glucemia > 600) {
        glucemia = 600;
    }
    
    self.amountLabel.text = [NSString stringWithFormat:@"%.0f", glucemia];
    [self doTextColorCheck];
}

- (void) doTextColorCheck
{
    CGFloat glucemiaValue = self.amountLabel.text.floatValue;
    
    if (glucemiaValue <= kHipoGlucemia || glucemiaValue >= kHiperGlucemia) {
        self.amountLabel.textColor = [UIColor colorWithRed:1 green:.2f blue:.2f alpha:.5f];
    } else {
        self.amountLabel.textColor  = [UIColor colorWithRed:58/255.f green:62/255.f blue:65/255.f alpha:1];
    }
}

- (void) hipoglucemiaFlow {
    
    UIColor *bgColor = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *textColor = [UIColor whiteColor];
    
    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Hipoglucemia" message:@"Usted ha indicado un valor de glucemia demasiado bajo, estando el mismo considerado dentro del rango de la hipoglucemia. ¿Desea continuar?" alertType:AlertTypeMultipleChoice];
    
    [alert addButton:@"Si" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        CGFloat glucemiaValue = self.amountLabel.text.floatValue;
        [HealthManager sharedInstance].glucemia = glucemiaValue;
        [self afterValueCheckFlow];
    }];
    
    [alert addButton:@"No" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
    }];
    
    [alert show];
    
}

- (void) hiperglucemiaFlow
{
    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Hiperglucemia" message:@"Usted ha indicado un valor de glucemia considerado dentro del rango de la hiperglucemia." closeButtonText:@"De acuerdo" closeButtonHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        
        CGFloat glucemiaValue = self.amountLabel.text.floatValue;
        [HealthManager sharedInstance].glucemia = glucemiaValue;
        [self afterValueCheckFlow];
    }];
    [alert show];
    
    
}

- (BOOL) checkEntryTimeAllowed {
    
    CGFloat spareTime = [[HealthManager sharedInstance] timeSinceLastEntry];
    CGFloat hours = spareTime/60.0f/60.0f;
    
    return hours > [self tiempoInsulinaActiva];
    
}

- (CGFloat) tiempoInsulinaActiva {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"InsulinaActivaKey"]) {
        return 2;
    }
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"InsulinaActivaKey"] floatValue];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continue:(id)sender
{
    
    CGFloat glucemiaValue = self.amountLabel.text.floatValue;
    
    //ERROR
    if (glucemiaValue < kMinGlucemia || glucemiaValue > kMaxGlucemia) {

        
        ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Fuera del Límite" message:[NSString stringWithFormat:@"Usted ha ingresado un valor inválido para la utilización de esta app. \n Glucemia Mínimo: %.2f \n Glucemia Máximo: %.2f ", kMinGlucemia, kMaxGlucemia] closeButtonText:@"De acuerdo" closeButtonHandler:^(ZAlertView * _Nonnull alertview) {
            [alertview dismissAlertView];
        }];
        [alert show];
        return;
    }
    
    //HIPOGLUCEMIA
    
    if (glucemiaValue >= kMinGlucemia && glucemiaValue < kHipoGlucemia) {
        [self hipoglucemiaFlow];
        return;
    }
    
    //HIPERGLUCEMIA
    if (glucemiaValue <= kMaxGlucemia && glucemiaValue > kHiperGlucemia) {
        [self hiperglucemiaFlow];
        return;
    }
    [self afterValueCheckFlow];
}

- (void) afterValueCheckFlow
{
    CGFloat glucemiaValue = self.amountLabel.text.floatValue;

    if (![self checkEntryTimeAllowed]) {
        [self glucemiaActivaFlow];
        return;
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"InsulinaActivaKey"]) {
        [self cambiarInsulinaActiva: NO];
        return;
    }
    
    [HealthManager sharedInstance].glucemia = glucemiaValue;
    
    [self performSegueWithIdentifier:@"nextStep" sender:nil];
}


- (void) glucemiaActivaFlow {
    
    CGFloat glucemiaValue = self.amountLabel.text.floatValue;
    UIColor *bgColor = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *textColor = [UIColor whiteColor];
    
    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Glucemia bloqueada" message:[NSString stringWithFormat:@"Este cálculo se realizara solo teniendo en cuenta los carbohidratos ingresados porque la duración de la insulina activa configurada es de %.0f horas", [self tiempoInsulinaActiva]] alertType:AlertTypeMultipleChoice];
    
    [alert addButton:@"De acuerdo" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        [HealthManager sharedInstance].glucemia = 0;
        [HealthManager sharedInstance].fakeGlucemia = glucemiaValue;
        [self performSegueWithIdentifier:@"nextStep" sender:nil];
    }];
    
    [alert addButton:@"Modificar duración" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        [self cambiarInsulinaActiva: YES];
    }];

    [alert show];
    
}

- (void) cambiarInsulinaActiva: (BOOL) dismiss
{
    UIColor *bgColor = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *textColor = [UIColor whiteColor];
    
    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Modificar duración de insulina activa" message:@"Elija la cantidad de horas indicada por su médico acerca del lapso de tiempo mínimo que debe transcurrir entre la aplicación de una dosis y la siguiente." alertType:AlertTypeMultipleChoice];
    
    for (NSNumber *value in @[@1,@2,@3,@4,@5,@6]) {

        [alert addButton:[NSString stringWithFormat:@"%.f horas", value.floatValue] color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
            [alertview dismissAlertView];
            [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"InsulinaActivaKey"];
            [self afterValueCheckFlow];
        }];
        
    }

    [alert addButton:@"Cancelar" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
    }];
    
    [alert show];
}


@end
