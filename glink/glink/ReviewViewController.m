//
//  ReviewViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 5/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "ReviewViewController.h"
#import "HealthManager.h"
#import "CarbsViewController.h"
#import "GlucemiaViewController.h"
#import "SlidersViewController.h"
#import "SegmentedScrollView.h"
#import "glink-Swift.h"


@interface ReviewViewController () <ButtonPressDelegate>
@property (weak, nonatomic) IBOutlet UILabel *relacion;
@property (weak, nonatomic) IBOutlet UILabel *sensibilidad;
@property (weak, nonatomic) IBOutlet UILabel *target;
@property (weak, nonatomic) IBOutlet UILabel *carbs;
@property (weak, nonatomic) IBOutlet UILabel *glucemia;
@property (weak, nonatomic) IBOutlet UISwitch *switchItem;
@property (weak, nonatomic) IBOutlet SegmentedScrollView *segmentedScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *stepcounter;

@property CGFloat reductionFactor;

@end

@implementation ReviewViewController

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reductionFactor = 1;
    self.carbs.text = [NSString stringWithFormat:@"%i", (int) [HealthManager sharedInstance].cantidadch];
    self.glucemia.text = [NSString stringWithFormat:@"%i", (int) [HealthManager sharedInstance].glucemia];

    self.segmentedScrollView.hardWidth = 70;
    [self.segmentedScrollView addButtons:@[@"Desayuno",@"Almuerzo",@"Merienda",@"Cena"]];
    self.segmentedScrollView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self preloadValues];
    [self stepCounterUpdate];
}

- (void) stepCounterUpdate
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SlidersViewController class]]) {
            self.stepcounter.image = [UIImage imageNamed:@"step4"];
            return;
        }
    }

    self.stepcounter.image = [UIImage imageNamed:@"step3-bis"];
}

- (void) preloadValues
{

    if ([HealthManager sharedInstance].relacionch>0) {
        self.relacion.text = [NSString stringWithFormat:@"%i", (int) [HealthManager sharedInstance].relacionch];
        self.sensibilidad.text = [NSString stringWithFormat:@"%i", (int) [HealthManager sharedInstance].sensibilidad];
        self.target.text = [NSString stringWithFormat:@"%i", (int) [HealthManager sharedInstance].target];
    } else {
        [self displayValuesForTimeframe:[self timeframeForCurrentHour]];
    }
    
    [self.segmentedScrollView setSelectedButton:[self titleForTimeframe:[self timeframeForCurrentHour]] animated:YES];
}

- (void) actionPressed: (UIButton *) sender
{
    [self.segmentedScrollView setSelectedButton:sender.titleLabel.text animated:YES];
    int timeframe = sender.tag + 1;
    [self displayValuesForTimeframe:timeframe];
    [self displayMessageForRecovering:[self descriptionForTimeframe:timeframe]];
}

- (void) displayMessageForRecovering: (NSString*) message {

    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Valores Predeterminados" message:[NSString stringWithFormat:@"Estos valores se cargan automáticamente en el siguiente periodo: %@", message] closeButtonText:@"De acuerdo" closeButtonHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
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

- (NSString *) titleForTimeframe: (NSInteger) timeframe {
    NSString* comida;
    switch (timeframe) {
        case 1: comida = @"Desayuno"; break;
        case 2: comida = @"Almuerzo"; break;
        case 3: comida = @"Merienda"; break;
        case 4: comida = @"Cena"; break;
        default:comida = nil;  break;
    }
    return comida;
}

- (IBAction)changeGlucemia:(id)sender {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[GlucemiaViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}


- (IBAction)changeCarbs:(id)sender {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[CarbsViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}
- (IBAction)changeOtherInfo:(id)sender {
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SlidersViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    [HealthManager sharedInstance].relacionch = self.relacion.text.floatValue;
    [HealthManager sharedInstance].target = self.target.text.floatValue;
    [HealthManager sharedInstance].sensibilidad = self.sensibilidad.text.floatValue;
    
    [self performSegueWithIdentifier:@"presentSliders" sender:nil];
}
- (IBAction)switchChanged:(id)sender {
    self.reductionFactor = 1;
    if (self.switchItem.on) {
        [self ejercicioFlow];
    }
}


- (void) ejercicioFlow {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Dosis Parcial"
                                  message:@"Si tienes pensado realizar ejercicio debes aplicarte una dosis parcial acorde al porcentaje (%) de reducción recomendado por tu médico."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSNumber *value in @[@10,@20,@25,@30,@40,@50,@60,@70,@80,@90]) {
        UIAlertAction* action = [UIAlertAction
                                 actionWithTitle:[NSString stringWithFormat:@"%.f%%", value.floatValue]
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     self.reductionFactor = (1 - value.integerValue/100.f);

                                     
                                 }];
        [alert addAction:action];
    }
    
    UIAlertAction* cancelar = [UIAlertAction
                               actionWithTitle:@"Cancelar"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action)
                               {
                                   self.reductionFactor = 1;
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:cancelar];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)nextStep:(id)sender {
    [HealthManager sharedInstance].relacionch = self.relacion.text.floatValue;
    [HealthManager sharedInstance].target = self.target.text.floatValue;
    [HealthManager sharedInstance].sensibilidad = self.sensibilidad.text.floatValue;
    [HealthManager sharedInstance].reductionFactor = self.reductionFactor;
    [self performSegueWithIdentifier:@"nextStep" sender:nil];
}

#pragma mark Timeframe


- (NSInteger) timeframeForCurrentHour {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:[NSDate date]];
    NSInteger hour = [components hour];
    NSLog(@"hour?? %i", hour);
    if (0<=hour&&hour<4)   { return 4;}
    if (4<=hour&&hour<12)  { return 1;}
    if (12<=hour&&hour<16) { return 2;}
    if (16<=hour&&hour<20) { return 3;}
    if (20<=hour&&hour<24) { return 4;}
    return 0;
}

- (void) displayValuesForTimeframe: (NSInteger) timeframe {
    
    CGFloat relacionValue = [[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat: @"relationValue-%lu", timeframe]];
    CGFloat targetValue = [[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat: @"targetValue-%lu", timeframe]];
    CGFloat sensibilidadValue = [[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat: @"sensibilidadValue-%lu", timeframe]];
    
    self.relacion.text = [NSString stringWithFormat:@"%g", relacionValue];
    self.target.text = [NSString stringWithFormat:@"%g", targetValue];
    self.sensibilidad.text = [NSString stringWithFormat:@"%g", sensibilidadValue];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"presentSliders"]) {
        UIViewController *nextVC = [segue destinationViewController];
        if ([nextVC isKindOfClass:[SlidersViewController class]]) {
            SlidersViewController *sliderVC = (SlidersViewController *) nextVC;
            sliderVC.isModal = YES;
        }
    }
}

@end
