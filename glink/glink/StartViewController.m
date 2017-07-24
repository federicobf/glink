//
//  StartViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 5/14/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "StartViewController.h"
#import "glink-Swift.h"

@interface StartViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property BOOL ticked;
@end

@implementation StartViewController


- (IBAction)tickon:(id)sender
{
    UIColor *lightBlue = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *darkGray =[UIColor colorWithRed:142/255.f green:142/255.f blue:147/255.f alpha:1];
    if (self.ticked) {
        self.untickImage.image = [UIImage imageNamed:@"tickoff"];
        self.startButton.backgroundColor = darkGray;
    } else {
        self.untickImage.image = [UIImage imageNamed:@"tickon"];
        self.startButton.backgroundColor = lightBlue;
    }
    
    self.ticked = !self.ticked;
}

- (IBAction)nextStep:(id)sender {
    
    if (self.ticked) {
        [self performSegueWithIdentifier:@"nextStep"sender:nil];
    } else {
        
        ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Terminos y condiciones" message:@"Por favor acepta los terminos y condiciones de la app antes de empezar a utilizarla." closeButtonText:@"De acuerdo" closeButtonHandler:^(ZAlertView * _Nonnull alertview) {
            [alertview dismissAlertView];
        }];
        [alert show];
        return;
    }
}

- (void)viewDidLoad {
    UIColor *darkGray =[UIColor colorWithRed:142/255.f green:142/255.f blue:147/255.f alpha:1];
    ZAlertView.positiveColor = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    ZAlertView.titleColor = [UIColor blackColor];
    ZAlertView.padding = 20;
    [super viewDidLoad];
    self.untickImage.image = [UIImage imageNamed:@"tickoff"];
    self.startButton.layer.cornerRadius = 23;
    self.startButton.layer.masksToBounds = YES;
    self.view.alpha = 0;
    self.startButton.backgroundColor = darkGray;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BOOL firstTimeSeen = [[NSUserDefaults standardUserDefaults] boolForKey:@"ftuSeen"];
    
    if (firstTimeSeen) {
        [self performSegueWithIdentifier:@"autoContinue"sender:nil];
    } else {
        [UIView animateWithDuration:.5f animations:^{
            self.view.alpha = 1;
        }];
    }
    
}

@end
