//
//  GlucemiaViewController.m
//  glink
//
//  Created by Federicuelo on 15/4/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "GlucemiaViewController.h"
#import "HealthManager.h"

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
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Hipoglucemia"
                                  message:@"Usted ha indicado un valor de glucemia demasiado bajo, estando el mismo considerado dentro del rango de la hipoglucemia. ¿Desea continuar?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction
                             actionWithTitle:@"Si"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 CGFloat glucemiaValue = self.amountLabel.text.floatValue;
                                 [HealthManager sharedInstance].glucemia = glucemiaValue;
                                 [self afterValueCheckFlow];
                                 
                             }];
    [alert addAction:action];
    
    UIAlertAction* cancelar = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:cancelar];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void) hiperglucemiaFlow {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Hiperglucemia"
                                  message:@"Usted ha indicado un valor de glucemia considerado dentro del rango de la hiperglucemia."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction
                             actionWithTitle:@"De acuerdo"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 CGFloat glucemiaValue = self.amountLabel.text.floatValue;
                                 [HealthManager sharedInstance].glucemia = glucemiaValue;
                                 [self afterValueCheckFlow];
                                 
                             }];
    [alert addAction:action];

    
    [self presentViewController:alert animated:YES completion:nil];
    
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
    if ((glucemiaValue < kMinGlucemia || glucemiaValue > kMaxGlucemia)&& [self checkEntryTimeAllowed]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fuera del Límite" message:[NSString stringWithFormat:@"Usted ha ingresado un valor inválido para la utilización de esta app. \n Glucemia Mínimo: %.2f \n Glucemia Máximo: %.2f ", kMinGlucemia, kMaxGlucemia] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
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
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Campo bloqueado"
                                  message:[NSString stringWithFormat:@"Tienen que pasar al menos %.f horas para que pueda volver a aplicarse una dosis relativa a su glucemia.", [self tiempoInsulinaActiva]]
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction
                             actionWithTitle:@"De acuerdo"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:action];
    
    UIAlertAction* cambiar = [UIAlertAction
                              actionWithTitle:@"Modificar duración"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  [self cambiarInsulinaActiva: YES];
                                  [alert dismissViewControllerAnimated:YES completion:nil];
                              }];
    [alert addAction:cambiar];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void) cambiarInsulinaActiva: (BOOL) dismiss {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Modificar duración de insulina activa"
                                  message:@"Elija la cantidad de horas indicada por su médico acerca del lapso de tiempo mínimo que debe transcurrir entre la aplicación de una dosis y la siguiente."
                                  preferredStyle:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)? UIAlertControllerStyleAlert: UIAlertControllerStyleActionSheet];
    
    for (NSNumber *value in @[@1,@2,@3,@4,@5,@6]) {
        UIAlertAction* action = [UIAlertAction
                                 actionWithTitle:[NSString stringWithFormat:@"%.f horas", value.floatValue]
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"InsulinaActivaKey"];
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [self afterValueCheckFlow];
                                     
                                 }];
        [alert addAction:action];
    }
    
    UIAlertAction* cancelar = [UIAlertAction
                               actionWithTitle:@"Cancelar"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:cancelar];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
