//
//  AddFoodViewController.m
//  glink
//
//  Created by Federicuelo on 23/4/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "AddFoodViewController.h"

@interface AddFoodViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *commentTextfield;

@end

@implementation AddFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nameTextfield becomeFirstResponder];
    self.nameTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    self.commentTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    self.nameTextfield.delegate = self;
    self.commentTextfield.delegate = self;
}
- (IBAction)sendButton:(id)sender {
    [self sendAction];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextfield) {
        [self.commentTextfield becomeFirstResponder];
    } else {
        [self sendAction];
    }
    return NO;
}

- (void) sendAction
{
    [self.navigationController popViewControllerAnimated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sugerencia enviada" message:[NSString stringWithFormat:@"Estaremos revisando tu sugerencia en los próximos días."] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
    [alert show];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
