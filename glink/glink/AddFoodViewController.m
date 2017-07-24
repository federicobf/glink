//
//  AddFoodViewController.m
//  glink
//
//  Created by Federicuelo on 23/4/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "AddFoodViewController.h"
#import "Firebase.h"
#import "MBProgressHUD.h"
#import "glink-Swift.h"

@interface AddFoodViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextfield;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation AddFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nameTextfield becomeFirstResponder];
    self.nameTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    self.commentTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    self.nameTextfield.delegate = self;
    self.commentTextfield.delegate = self;
    self.blurView.alpha = 0;
    self.blurView.hidden = YES;
}
- (IBAction)sendButton:(id)sender
{
    [self checkAndSend];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextfield) {
        [self.commentTextfield becomeFirstResponder];
    } else {
        [self checkAndSend];
    }
    return NO;
}

- (void) checkAndSend
{
    if (self.nameTextfield.text.length == 0) {
        ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Error" message:@"Completa el campo de sugerencias." closeButtonText:@"De acuerdo" closeButtonHandler:^(ZAlertView * _Nonnull alertview) {
            [alertview dismissAlertView];
        }];
        [alert show];
        
        return;
    }
    
    [self sendAction];
}

- (void) sendAction
{
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    [self.nameTextfield resignFirstResponder];
    [self.commentTextfield resignFirstResponder];
 //   self.blurView.hidden = NO;
    hud.label.text = @"Enviando sugerencia";
    hud.contentColor = [UIColor blackColor];

    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleBlur;

    self.ref = [[FIRDatabase database] reference];
    [self.ref runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
        NSMutableDictionary *post = currentData.value;
        if (!post || [post isEqual:[NSNull null]]) {
            return [FIRTransactionResult successWithValue:currentData];
        }
        post[self.nameTextfield.text] = self.commentTextfield.text.length>0?self.commentTextfield.text: @"Sin comentario";
        
        // Set value and report transaction success
        currentData.value = post;
        return [FIRTransactionResult successWithValue:currentData];
    } andCompletionBlock:^(NSError * _Nullable error,
                           BOOL committed,
                           FIRDataSnapshot * _Nullable snapshot) {
        // Transaction completed
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }

        ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Sugerencia enviada" message:@"Estaremos revisando tu sugerencia en los próximos días." closeButtonText:@"De acuerdo" closeButtonHandler:^(ZAlertView * _Nonnull alertview) {
            [alertview dismissAlertView];
            [MBProgressHUD hideHUDForView:self.view.window animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert show];


    }];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
