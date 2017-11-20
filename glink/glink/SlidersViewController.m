//
//  SlidersViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 4/23/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "SlidersViewController.h"
#import "glink-Swift.h"

@implementation SlidersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftButton.layer.cornerRadius = 23;
    self.leftButton.layer.masksToBounds = YES;
    
    self.rightButton.layer.cornerRadius = 23;
    self.rightButton.layer.masksToBounds = YES;
    
   //SETUP INICIAL
    self.scrollview.delaysContentTouches = NO;
    self.scrollview.canCancelContentTouches = NO;
}

- (void)viewWillAppear:(BOOL)animated {

    if (self.isModal || [HealthManager sharedInstance].relacionch>0) {
        [self displayLastShownValues];
    } else {
        [self preloadMinimumValues];
    }
}

- (IBAction)relationSliderChanged:(id)sender {
    //UPDATE LABEL WITH SLIDER
    float sliderValue = self.relSlider.value;
    float relationValue = sliderValue * (kMaxRelacion - kMinRelacion) + kMinRelacion;

    NSString *relationText = [NSString stringWithFormat:@"%.0f", relationValue];
    self.relLabel.text = relationText;
}

- (IBAction)targetSliderChanged:(id)sender {
    
    float sliderValue = self.objetivoSlider.value;
    float targetValue = sliderValue * (kMaxTarget - kMinTarget) + kMinTarget;
 
    
    NSString *targetText = [NSString stringWithFormat:@"%.0f", targetValue];
    self.objetivoLabel.text = targetText;
    
}
                                  
- (IBAction)sensibilidadSliderChanged:(id)sender {

    float sliderValue = self.sensibilidadSlider.value;
    float sensibilidadvalue = sliderValue * (kMaxSensibilidad - kMinSensibilidad) + kMinSensibilidad;

    
    NSString *sensibilidadText = [NSString stringWithFormat:@"%.0f", sensibilidadvalue];
    self.sensibilidadLabel.text = sensibilidadText;
    
}

- (IBAction)continuar:(id)sender {
    
    float relationValue = self.relSlider.value * (kMaxRelacion - kMinRelacion) + kMinRelacion;
    float targetValue = self.objetivoSlider.value * (kMaxTarget - kMinTarget) + kMinTarget;
    float sensibilidadvalue = self.sensibilidadSlider.value * (kMaxSensibilidad - kMinSensibilidad) + kMinSensibilidad;
    if (fabs (relationValue - kDefRelacion) < .1f &&
        fabs (targetValue - kDefTarget) < .1f &&
        fabs (sensibilidadvalue - kDefSensibilidad) < .1f) {
        [self advertenciaStep];
    } else {
        [self continueStep];
    }
    
}

- (void) advertenciaStep
{
    UIColor *bgColor = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *textColor = [UIColor whiteColor];
    
    
    
    
    
    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Advertencia" message:@"Usted no ha modificado los valores preconfigurados. Recuerde que es importante que datermine estos valores con su medico para que los resultados del cálculo sean válidos." alertType:AlertTypeMultipleChoice];
    
    
    [alert addButton:@"He revisado este dato" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        [self continueStep];
    }];
    
    [alert addButton:@"Modificar" color:bgColor titleColor:textColor  touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
    }];
    
    [alert show];
}

- (void) continueStep
{
    if (self.isModal) {
        [self consultaGuardarValores];
    } else {
        [self saveAllDay];
        [HealthManager sharedInstance].relacionch = self.relLabel.text.floatValue;
        [HealthManager sharedInstance].target = self.objetivoLabel.text.floatValue;
        [HealthManager sharedInstance].sensibilidad = self.sensibilidadLabel.text.floatValue;
        [self performSegueWithIdentifier:@"nextStep" sender:nil];
    }
}

- (IBAction)backAction:(id)sender
{
    if (self.isModal) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//save data

- (void) consultaGuardarValores
{
    UIColor *bgColor = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *textColor = [UIColor whiteColor];
    
    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Valores Predeterminados" message:@"¿Desea que estos valores se carguen automaticamente en un próximo uso?" alertType:AlertTypeMultipleChoice];
    
 
    [alert addButton:@"Sí" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        [self guardarValores];
    }];
    
    [alert addButton:@"No" color:bgColor titleColor:textColor  touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        
        [HealthManager sharedInstance].relacionch = self.relLabel.text.floatValue;
        [HealthManager sharedInstance].target = self.objetivoLabel.text.floatValue;
        [HealthManager sharedInstance].sensibilidad = self.sensibilidadLabel.text.floatValue;
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert show];
    
}

- (void)guardarValores {
    
    UIColor *bgColor = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *textColor = [UIColor whiteColor];
    
    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Guardar valores" message:@"Elija cual es la comida en la que quiere que se carguen automáticamente estos datos:" alertType:AlertTypeMultipleChoice];
    
    
    [alert addButton:@"Desayuno" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        [self saveValuesForTimeframe:1];
        [self displayMessageForSaving:[self descriptionForTimeframe:1]];
    }];
    
    [alert addButton:@"Almuerzo" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        [self saveValuesForTimeframe:2];
        [self displayMessageForSaving:[self descriptionForTimeframe:2]];
    }];
    
    [alert addButton:@"Merienda" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        [self saveValuesForTimeframe:3];
        [self displayMessageForSaving:[self descriptionForTimeframe:3]];
    }];
    
    [alert addButton:@"Cena" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        [self saveValuesForTimeframe:4];
        [self displayMessageForSaving:[self descriptionForTimeframe:4]];
    }];
    
    [alert addButton:@"Todos" color:bgColor titleColor:textColor  touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        [self saveAllDay];
        [self displayMessageForSaving:@"Todo el dia"];
    }];
    
    [alert show];
    
    
}

- (NSString *) descriptionForTimeframe: (NSInteger) timeframe {
    switch (timeframe) {
        case 1: return @"4AM a 12PM"; break;
        case 2: return @"12PM a 4PM"; break;
        case 3: return @"4PM a 8PM"; break;
        case 4: return @"8PM a 4AM"; break;
        default: return nil;
    }
    
}

- (void) saveAllDay {
    [self saveValuesForTimeframe:1];
    [self saveValuesForTimeframe:2];
    [self saveValuesForTimeframe:3];
    [self saveValuesForTimeframe:4];
}

- (void) saveValuesForTimeframe: (NSInteger) timeframe {
    
    CGFloat relacionValue = self.relLabel.text.floatValue;
    CGFloat targetValue = self.objetivoLabel.text.floatValue;
    CGFloat sensibilidadValue = self.sensibilidadLabel.text.floatValue;
    
    [[NSUserDefaults standardUserDefaults] setFloat:relacionValue forKey:[NSString stringWithFormat: @"relationValue-%lu", timeframe]];
    [[NSUserDefaults standardUserDefaults] setFloat:targetValue forKey:[NSString stringWithFormat: @"targetValue-%lu", timeframe]];
    [[NSUserDefaults standardUserDefaults] setFloat:sensibilidadValue forKey:[NSString stringWithFormat: @"sensibilidadValue-%lu", timeframe]];
    
    [HealthManager sharedInstance].relacionch = self.relLabel.text.floatValue;
    [HealthManager sharedInstance].target = self.objetivoLabel.text.floatValue;
    [HealthManager sharedInstance].sensibilidad = self.sensibilidadLabel.text.floatValue;
}

- (void) displayMessageForSaving: (NSString*) message {
    

    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Valores Predeterminados" message:[NSString stringWithFormat:@"En los próximos usos estos valores serán cargados de antemano durante el siguiente periodo: %@", message] closeButtonText:@"De acuerdo" closeButtonHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert show];
    
    
}

- (void) displayLastShownValues
{
    self.relLabel.text = [NSString stringWithFormat:@"%g", [HealthManager sharedInstance].relacionch];
    self.objetivoLabel.text = [NSString stringWithFormat:@"%g", [HealthManager sharedInstance].target];
    self.sensibilidadLabel.text = [NSString stringWithFormat:@"%g", [HealthManager sharedInstance].sensibilidad];

    float sliderValue = ([HealthManager sharedInstance].relacionch - kMinRelacion) / (kMaxRelacion - kMinRelacion);
    self.relSlider.value = sliderValue;
    
    float slider2Value = ([HealthManager sharedInstance].target - kMinTarget) / (kMaxTarget - kMinTarget);
    self.objetivoSlider.value = slider2Value;
    
    float slider3Value = ([HealthManager sharedInstance].sensibilidad - kMinSensibilidad) / (kMaxSensibilidad - kMinSensibilidad);
    self.sensibilidadSlider.value = slider3Value;
}

- (void) preloadMinimumValues
{
    NSString *relationText = [NSString stringWithFormat:@"%.0f", kDefRelacion];
    self.relLabel.text = relationText;
    
    NSString *targetText = [NSString stringWithFormat:@"%.0f", kDefTarget];
    self.objetivoLabel.text = targetText;

    
    NSString *sensibilidadText = [NSString stringWithFormat:@"%.0f", kDefSensibilidad];
    self.sensibilidadLabel.text = sensibilidadText;
    
    
    float sliderValue = (kDefRelacion - kMinRelacion) / (kMaxRelacion - kMinRelacion);
    self.relSlider.value = sliderValue;
    
    float slider2Value = (kDefTarget - kMinTarget) / (kMaxTarget - kMinTarget);
    self.objetivoSlider.value = slider2Value;
    
    float slider3Value = (kDefSensibilidad - kMinSensibilidad) / (kMaxSensibilidad - kMinSensibilidad);
    self.sensibilidadSlider.value = slider3Value;
}

@end
