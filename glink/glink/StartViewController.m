//
//  StartViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 5/14/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property BOOL ticked;
@end

@implementation StartViewController


- (IBAction)tickon:(id)sender
{
    if (self.ticked) {
        self.untickImage.image = [UIImage imageNamed:@"tickoff"];
    } else {
        self.untickImage.image = [UIImage imageNamed:@"tickon"];
    }
    
    self.ticked = !self.ticked;
}

- (IBAction)nextStep:(id)sender {
    if (self.ticked) {
        [self performSegueWithIdentifier:@"nextStep"sender:nil];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Terminos y condiciones"
                                                        message:@"Por favor acepta los terminos y condiciones de la app antes de empezar a utilizarla."
                                                       delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
        [alert show];
        return;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.untickImage.image = [UIImage imageNamed:@"tickoff"];
    self.startButton.layer.cornerRadius = 23;
    self.startButton.layer.masksToBounds = YES;
    self.view.alpha = 0;
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
