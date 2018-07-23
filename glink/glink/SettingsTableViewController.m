//
//  SettingsTableViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 8/7/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "SettingsTableViewController.h"
#import <MessageUI/MessageUI.h>
#import "glink-Swift.h"

@interface SettingsTableViewController ()<UITableViewDelegate, MFMailComposeViewControllerDelegate>
@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [self sendEmailTo:@"info@glink.com.ar"];
    }
    
    if (indexPath.row == 2) {
        [self gotoReviews];
    }
    
    if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"terms" sender:nil];
    }
    
    if (indexPath.row == 4) {
        [self askToErase];
    }
}

- (void) askToErase {
    UIColor *bgColor = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *textColor = [UIColor whiteColor];
    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Borrar registro" message:@"¿Estás seguro de que deseas borrar todo tu historial de registros de la aplicación?" alertType:AlertTypeMultipleChoice];
    
    [alert addButton:@"Borrar ítems" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [self eraseAllData];
        [alertview dismissAlertView];
    }];
    
    [alert addButton:@"Cancelar" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
    }];
    
    [alert show];
    
}

- (void) eraseAllData
{
    NSMutableArray* items = [NSMutableArray new];
    [[NSUserDefaults standardUserDefaults] setObject:items forKey:@"HealthItems"];
}

- (IBAction)gotoReviews
{
    NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
    str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
    str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
    
    // Here is the app id from itunesconnect
    str = [NSString stringWithFormat:@"%@1315509045", str];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void) sendEmailTo: (NSString *) recipient
{
    // Email Subject
    NSString *emailTitle = @"Consulta de la app";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:recipient];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    if (mc) {
        [self presentViewController:mc animated:YES completion:NULL];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
