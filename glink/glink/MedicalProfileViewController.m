//
//  MedicalProfileViewController.m
//  glink
//
//  Created by Federicuelo on 28/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "MedicalProfileViewController.h"
#import "MedicalProfileTableViewCell.h"

@interface MedicalProfileViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *roundContainerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation MedicalProfileViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.roundContainerView.layer.cornerRadius = self.roundContainerView.bounds.size.width/2;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


- (IBAction)segmentedControlChanged:(id)sender {
    
    NSLog(@"segmented %li", self.segmentedControl.selectedSegmentIndex);
    [self.tableView reloadData];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        return [self celdaMedicoForIndexPath:indexPath];
    } else {
        return [self celdaPacienteForIndexPath:indexPath];
    }
}

- (UITableViewCell *) celdaMedicoForIndexPath: (NSIndexPath *) indexPath
{
    MedicalProfileTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.cellTextField.delegate = self;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        cell.cellLabel.text = @"Email";
        cell.cellTextField.tag = 201;
    }
    
    if (indexPath.row == 1) {
        cell.cellLabel.text = @"Teléfono";
        cell.cellTextField.tag = 202;
    }
    
    if (indexPath.row == 2) {
        cell.cellLabel.text = @"Web";
        cell.cellTextField.tag = 203;
    }
    
    if (indexPath.row == 3) {
        cell.cellLabel.text = @"Ubicación";
        cell.cellTextField.tag = 204;
    }
    
    //RECUPERO UN VALOR
    NSString *tagString= [NSString stringWithFormat:@"%li", (long)cell.cellTextField.tag];
    cell.cellTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:tagString];

    return cell;
}

- (UITableViewCell *) celdaPacienteForIndexPath: (NSIndexPath *) indexPath
{
    MedicalProfileTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.cellTextField.delegate = self;
    
    if (indexPath.row == 0) {
        cell.cellLabel.text = @"Altura";
        cell.cellTextField.tag = 101;
    }
    
    if (indexPath.row == 1) {
        cell.cellLabel.text = @"Sexo";
        cell.cellTextField.tag = 102;
    }
    
    if (indexPath.row == 2) {
        cell.cellLabel.text = @"Web";
        cell.cellTextField.tag = 103;
    }
    
    if (indexPath.row == 3) {
        cell.cellLabel.text = @"Edad";
        cell.cellTextField.tag = 104;
    }
    
    //RECUPERO UN VALOR
    
    NSString *tagString= [NSString stringWithFormat:@"%li", (long)cell.cellTextField.tag];
    cell.cellTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:tagString];
    
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

    NSInteger tag = textField.tag;
    NSString *text = textField.text;
    
    NSString *tagString= [NSString stringWithFormat:@"%li", (long)tag];
    
    //GUARDO ESTE VALOR bajo la key tagstring
    [[NSUserDefaults standardUserDefaults] setObject:text forKey:tagString];
    
    
    
    NSLog(@"El textfield con el tag %i escribio el texto %@ y debe ser guardado", tag, text);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
