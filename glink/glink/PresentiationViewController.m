//
//  PresentiationViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 7/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "PresentiationViewController.h"
#import "PresentationView.h"
#import <MessageUI/MessageUI.h>
#import "glink-Swift.h"


@interface PresentiationViewController () <MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) PresentationView *presentationView;
@property (nonatomic, strong) NSData *pdfData;
@end

@implementation PresentiationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"PresentationView"
                                                    owner:self options:nil];
    self.imageView.alpha = 0;

    for (UIView *object in bundle) {
        if ([object isKindOfClass:[PresentationView class]]) {
            self.presentationView = (PresentationView *)object;
            break;
        }
    }
    [self.view addSubview:self.presentationView];
    self.presentationView.frame = CGRectMake(0, 0, 612, 792);
    [self.presentationView setUpWithPresentationItem:self.presentationItem];
    [self.view sendSubviewToBack:self.presentationView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    if (self.pdfData) {
        return;
    }
    
    UIView *presentationView = self.presentationView;
    UIGraphicsBeginImageContextWithOptions(presentationView.bounds.size, presentationView.opaque, 0.0f);
    [presentationView drawViewHierarchyInRect:presentationView.bounds afterScreenUpdates:NO];
    UIImage *snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image =  snapshotImageFromMyView;
    [UIView animateWithDuration:.3f animations:^{
        self.imageView.alpha = 1;
    }];

    self.pdfData = [self makePDFfromView:self.presentationView];
    [self.presentationView removeFromSuperview];
}

- (IBAction)sendMail:(id)sender {
        
    MFMailComposeViewController *mail=[[MFMailComposeViewController alloc]init];
    mail.mailComposeDelegate=self;
    [mail setSubject:@"Reporte glink"];
    [mail addAttachmentData:self.pdfData mimeType:@"application/pdf" fileName:@"reporte_glink.pdf"];
    NSString * body = @"Reporte de salud actualizado de los ultimos meses";
    [mail setMessageBody:body isHTML:NO];
    if (mail) {
        [self presentViewController:mail animated:YES completion:nil];
    }
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
            ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Mail cancelado" message:@"Tu reporte se canceló correctamente" closeButtonText:@"De acuerdo" closeButtonHandler:^(ZAlertView * _Nonnull alertview) {
                [alertview dismissAlertView];
            }];
            [alert show];
        }
            break;
        case MFMailComposeResultSaved:
        {
            ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Mail guardado" message:@"Tu reporte se guardó correctamente" closeButtonText:@"De acuerdo" closeButtonHandler:^(ZAlertView * _Nonnull alertview) {
                [alertview dismissAlertView];
            }];
            [alert show];
        }
            break;
        case MFMailComposeResultSent:
        {
            ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Mail enviado" message:@"Tu reporte se envió correctamente" closeButtonText:@"De acuerdo" closeButtonHandler:^(ZAlertView * _Nonnull alertview) {
                [alertview dismissAlertView];
            }];
            [alert show];
        }
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
        {
            ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Error" message:@"Tu reporte no se envió correctamente" closeButtonText:@"De acuerdo" closeButtonHandler:^(ZAlertView * _Nonnull alertview) {
                [alertview dismissAlertView];
            }];
            [alert show];
        }
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(NSData*)makePDFfromView:(UIView*)view
{
    NSMutableData *pdfData = [NSMutableData data];
    
    UIGraphicsBeginPDFContextToData(pdfData, view.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:pdfContext];
    UIGraphicsEndPDFContext();
    
    return pdfData;
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
