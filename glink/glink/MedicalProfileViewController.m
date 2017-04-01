//
//  MedicalProfileViewController.m
//  glink
//
//  Created by Federicuelo on 28/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "MedicalProfileViewController.h"
#import "MedicalProfileTableViewCell.h"

@interface MedicalProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *roundContainerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MedicalProfileViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.roundContainerView.layer.cornerRadius = self.roundContainerView.bounds.size.width/2;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    MedicalProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    
    
    if (indexPath.row == 1) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.cellLabel.text = @"Teléfono";
    }
    
    
    if (indexPath.row == 2) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.cellLabel.text = @"Web";
    }
    
    
    return cell;
}

@end
