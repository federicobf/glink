//
//  SettingsViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 8/7/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "SettingsViewController.h"
#import <MessageUI/MessageUI.h>

@interface SettingsViewController ()<UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
