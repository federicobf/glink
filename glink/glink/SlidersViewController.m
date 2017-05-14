//
//  SlidersViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 4/23/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "SlidersViewController.h"

@implementation SlidersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftButton.layer.cornerRadius = 23;
    self.leftButton.layer.masksToBounds = YES;
    
    self.rightButton.layer.cornerRadius = 23;
    self.rightButton.layer.masksToBounds = YES;
    
   //SETUP INICIAL
    self.scrollview.delaysContentTouches = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (self.isModal) {
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Guardar valores"
                                                    message:@"¿Desea que estos valores se carguen automaticamente en un próximo uso?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Sí", nil];
    alert.tag = 2;
    [alert show];
}

- (void)guardarValores {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Guardar valores"
                                  message:@"Elige cual es la comida en la que quieres que se carguen automáticamente estos datos:"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* opt1 = [UIAlertAction
                           actionWithTitle:@"Desayuno"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [self saveValuesForTimeframe:1];
                               [self displayMessageForSaving:[self descriptionForTimeframe:1]];
                               [alert dismissViewControllerAnimated:YES completion:nil];
                               
                           }];
    UIAlertAction* opt2 = [UIAlertAction
                           actionWithTitle:@"Almuerzo"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [self saveValuesForTimeframe:2];
                               [self displayMessageForSaving:[self descriptionForTimeframe:2]];
                               [alert dismissViewControllerAnimated:YES completion:nil];
                           }];
    UIAlertAction* opt3 = [UIAlertAction
                           actionWithTitle:@"Colación"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [self saveValuesForTimeframe:3];
                               [self displayMessageForSaving:[self descriptionForTimeframe:3]];
                               [alert dismissViewControllerAnimated:YES completion:nil];
                               
                           }];
    UIAlertAction* opt4 = [UIAlertAction
                           actionWithTitle:@"Cena"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [self saveValuesForTimeframe:4];
                               [self displayMessageForSaving:[self descriptionForTimeframe:4]];
                               [alert dismissViewControllerAnimated:YES completion:nil];
                           }];
    
    UIAlertAction* opt5 = [UIAlertAction
                           actionWithTitle:@"Todos"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [self saveAllDay];
                               [self displayMessageForSaving:@"Todo el dia"];
                               [alert dismissViewControllerAnimated:YES completion:nil];
                           }];
    
    [alert addAction:opt1];
    [alert addAction:opt2];
    [alert addAction:opt3];
    [alert addAction:opt4];
    [alert addAction:opt5];
    
    [self presentViewController:alert animated:YES completion:nil];
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

- (IBAction)segmentedControlChanged:(id)sender {
    
    //    [self displayValuesForTimeframe:self.segmentedControl.selectedSegmentIndex+1];
    
    
    //    NSString* comida;
    //    switch (self.segmentedControl.selectedSegmentIndex) {
    //        case 0: comida = @"DESAYUNO"; break;
    //        case 1: comida = @"ALMUERZO"; break;
    //        case 2: comida = @"MERIENDA"; break;
    //        case 3: comida = @"CENA"; break;
    //        default:comida = @"ERROR";  break;
    //    }
    //
    //    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Valores Predeterminados" message:[NSString stringWithFormat:@"Acabas de cargar manualmente los datos correspondientes a la siguiente comida: %@", comida] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
    //    [alert show];
    
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
    
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Valores Predeterminados" message:[NSString stringWithFormat:@"En los próximos usos estos valores serán cargados de antemano durante el siguiente periodo: %@", message] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
    alert.tag = 0;
    [alert show];
    alert.delegate = self;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 0) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            CGFloat relacionValue = self.relLabel.text.floatValue;
            CGFloat targetValue = self.objetivoLabel.text.floatValue;
            CGFloat sensibilidadValue = self.sensibilidadLabel.text.floatValue;
            
            [HealthManager sharedInstance].relacionch = self.relLabel.text.floatValue;
            [HealthManager sharedInstance].target = self.objetivoLabel.text.floatValue;
            [HealthManager sharedInstance].sensibilidad = self.sensibilidadLabel.text.floatValue;
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self guardarValores];
        }
    }
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
    NSString *relationText = [NSString stringWithFormat:@"%.0f", kMinRelacion];
    self.relLabel.text = relationText;
    self.relSlider.value = 0;
    
    NSString *targetText = [NSString stringWithFormat:@"%.0f", kMinTarget];
    self.objetivoLabel.text = targetText;
    self.objetivoSlider.value = 0;
    
    NSString *sensibilidadText = [NSString stringWithFormat:@"%.0f", kMinSensibilidad];
    self.sensibilidadLabel.text = sensibilidadText;
    self.sensibilidadSlider.value = 0;
}

@end
