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
@property BOOL secondTicked;
@end

@implementation StartViewController


- (IBAction)tickon2:(id)sender
{

    if (self.ticked) {
        self.untickImage.image = [UIImage imageNamed:@"tickoff"];
    } else {
        self.untickImage.image = [UIImage imageNamed:@"tickon"];
    }
    
    self.ticked = !self.ticked;
    
    [self updateButton];
}
- (IBAction)tickon:(id)sender
{
    if (self.secondTicked) {
        self.secondUntickImage.image = [UIImage imageNamed:@"tickoff"];
    } else {
        self.secondUntickImage.image = [UIImage imageNamed:@"tickon"];
    }
    
    
    self.secondTicked = !self.secondTicked;
    [self updateButton];
}

- (void) updateButton
{
    UIColor *lightBlue = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *darkGray =[UIColor colorWithRed:142/255.f green:142/255.f blue:147/255.f alpha:1];
    if (self.ticked && self.secondTicked) {
        self.startButton.backgroundColor = lightBlue;
    } else {
        self.startButton.backgroundColor = darkGray;
    }
    

}

- (IBAction)nextStep:(id)sender {
    
    if (self.ticked && self.secondTicked) {
        [self performSegueWithIdentifier:@"nextStep"sender:nil];
        self.tabBarController.selectedIndex = 2;
    } else {
        
        ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Términos y condiciones" message:@"Debe aceptar ambas condiciones para poder comenzar a utilizar la aplicacion." closeButtonText:@"De acuerdo" closeButtonHandler:^(ZAlertView * _Nonnull alertview) {
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
