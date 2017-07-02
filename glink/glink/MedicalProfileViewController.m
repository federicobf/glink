//
//  MedicalProfileViewController.m
//  glink
//
//  Created by Federicuelo on 28/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "MedicalProfileViewController.h"
#import "MedicalProfileTableViewCell.h"

@interface MedicalProfileViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *roundContainerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UITextField *fakeTitleTextfield;
@property (strong, nonatomic) UITextField *fakeSubtitleTextfield;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (strong, nonatomic) IBOutlet UIImage *userPhoto;
@property (strong, nonatomic) IBOutlet UIImage *doctorPhoto;

@end

@implementation MedicalProfileViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self createFakeTextfield];
    [self setUpScrollView];

    
    self.roundContainerView.layer.cornerRadius = self.roundContainerView.bounds.size.width/2;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
   
    
    self.profilePhoto.image =  [UIImage imageNamed:@"profileimage"];
    
    
    
}

- (void) setUpScrollView {
    
     UIColor *darkGray =[UIColor colorWithRed:142/255.f green:142/255.f blue:147/255.f alpha:1];
    UIColor *paleBlue = [UIColor colorWithRed:232/255.f green:244/255.f blue:253/255.f alpha:1];
    UIColor *lightBlue = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *lightGray = [UIColor colorWithRed:243/255.f green:244/255.f blue:245/255.f alpha:1];
    
    self.segmentedControl.tintColor = paleBlue;
    self.segmentedControl.backgroundColor =  lightGray;
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
    [UIFont systemFontOfSize:13.0], NSFontAttributeName,
    lightBlue, NSForegroundColorAttributeName,
    paleBlue, NSBackgroundColorAttributeName, nil];
   
    
    [self.segmentedControl setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    NSDictionary *unselectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
    [UIFont systemFontOfSize:13.0], NSFontAttributeName,
    darkGray, NSForegroundColorAttributeName,
    lightGray, NSBackgroundColorAttributeName, nil];
    [self.segmentedControl setTitleTextAttributes:unselectedAttributes forState:UIControlStateNormal];

}

- (IBAction)segmentedControlChanged:(id)sender {
    [self.tableView reloadData];
    
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        self.profilePhoto.image =  self.doctorPhoto != nil? self.doctorPhoto : [UIImage imageNamed:@"profileimage"];
    
    } else {
        self.profilePhoto.image = self.userPhoto != nil? self.userPhoto : [UIImage imageNamed:@"profileimage"];
    }
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
    UIColor *lightGray = [UIColor colorWithRed:243/255.f green:244/255.f blue:245/255.f alpha:1];
    MedicalProfileTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    
    cell.cellTextField.delegate = self;
    cell.backgroundColor = [UIColor whiteColor];
    cell.line.backgroundColor = lightGray;
    cell.buttonWidth.constant = 76;
    cell.indexPath = indexPath;
    cell.cellTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.cellLabel.text = @"Email";
        [cell.cellButton setTitle:@"ENVIAR MAIL" forState:UIControlStateNormal];
        cell.cellTextField.tag = 201;
        
    }
    
    if (indexPath.row == 1) {
        cell.cellLabel.text = @"Teléfono";
        cell.cellTextField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.cellButton setTitle:@"LLAMAR" forState:UIControlStateNormal];
        cell.cellTextField.tag = 202;
    }
    
    if (indexPath.row == 2) {
        cell.cellLabel.text = @"Web";
        [cell.cellButton setTitle:@"ENTRAR" forState:UIControlStateNormal];
        cell.cellTextField.tag = 203;
    }
    
    if (indexPath.row == 3) {
        cell.cellLabel.text = @"Ubicación";
        [cell.cellButton setTitle:@"VER MAPA" forState:UIControlStateNormal];
        cell.cellTextField.tag = 204;
    }
    
    //RECUPERO UN VALOR
    NSString *tagString= [NSString stringWithFormat:@"%li", (long)cell.cellTextField.tag];
    cell.cellTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:tagString];

    return cell;
}
- (IBAction)sendMail:(id)sender {
    
    UIButton *buttonSendMail = (UIButton *) sender;
    MedicalProfileTableViewCell *cell = (MedicalProfileTableViewCell *) buttonSendMail.superview.superview;
    NSIndexPath *indexPath = cell.indexPath;
    
    if (indexPath.row == 0) {
        
        
        
    }
    
    if (indexPath.row == 1) {
        
        NSString *stringPath = [NSString stringWithFormat:@"telprompt://%@", cell.cellTextField.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringPath]];
    }
    
    if (indexPath.row == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: cell.cellTextField.text]];
        
    }


    
}


- (UITableViewCell *) celdaPacienteForIndexPath: (NSIndexPath *) indexPath
{
    UIColor *lightGray = [UIColor colorWithRed:243/255.f green:244/255.f blue:245/255.f alpha:1];
    MedicalProfileTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.cellTextField.delegate = self;
    cell.line.backgroundColor = lightGray;
    cell.buttonWidth.constant = 0;
    cell.indexPath = indexPath;
    cell.cellTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    if (indexPath.row == 0) {
        cell.cellLabel.text = @"Altura";
        [cell.cellButton setTitle:@"" forState:UIControlStateNormal];
        cell.cellTextField.tag = 101;
        cell.cellTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    if (indexPath.row == 1) {
        cell.cellLabel.text = @"Sexo";
        [cell.cellButton setTitle:@"" forState:UIControlStateNormal];
        cell.cellTextField.tag = 102;
    }
    
    if (indexPath.row == 2) {
        cell.cellLabel.text = @"Web";
        [cell.cellButton setTitle:@"" forState:UIControlStateNormal];
        cell.cellTextField.tag = 103;
    }
    
    if (indexPath.row == 3) {
        cell.cellLabel.text = @"Edad";
        [cell.cellButton setTitle:@"" forState:UIControlStateNormal];
        cell.cellTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.cellTextField.tag = 104;
    }
    
    //RECUPERO UN VALOR
    
    NSString *tagString= [NSString stringWithFormat:@"%li", (long)cell.cellTextField.tag];
    cell.cellTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:tagString];
    
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

    if (textField.tag == 0) {
        return;
    }
    
    NSInteger tag = textField.tag;
    NSString *text = textField.text;
    
    NSString *tagString= [NSString stringWithFormat:@"%li", (long)tag];
    
    //GUARDO ESTE VALOR bajo la key tagstring
    [[NSUserDefaults standardUserDefaults] setObject:text forKey:tagString];
    
    UIColor *lightGray = [UIColor colorWithRed:243/255.f green:244/255.f blue:245/255.f alpha:1];
    MedicalProfileTableViewCell *cell = (MedicalProfileTableViewCell *) textField.superview.superview;
    cell.line.backgroundColor = lightGray;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    NSLog(@"El textfield con el tag %i escribio el texto %@ y debe ser guardado", tag, text);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 0) {
        return;
    }
    
    UIColor *lightBlue = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 140, 0);
    MedicalProfileTableViewCell *cell = (MedicalProfileTableViewCell *) textField.superview.superview;
    cell.line.backgroundColor = lightBlue;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.tableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//metodos de texto magico de arriba
- (void) createFakeTextfield
{
    self.fakeTitleTextfield = [UITextField new];
    self.fakeTitleTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    self.fakeTitleTextfield.delegate = self;
    [self.view addSubview:self.fakeTitleTextfield];
    
    self.fakeSubtitleTextfield = [UITextField new];
    self.fakeSubtitleTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    self.fakeSubtitleTextfield.delegate = self;
    [self.view addSubview:self.fakeSubtitleTextfield];
}

- (IBAction)editLabelName:(id)sender
{
    self.titleLabel.text = @"";
    self.fakeTitleTextfield.text = self.titleLabel.text;
    [self.fakeTitleTextfield becomeFirstResponder];
}
- (IBAction)editLabelMail:(id)sender
{
    self.subtitleLabel.text = @"";
    self.fakeSubtitleTextfield.text = self.subtitleLabel.text;
    [self.fakeSubtitleTextfield becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.fakeTitleTextfield) {
        self.titleLabel.text = newText;
    }
    
    if (textField == self.fakeSubtitleTextfield) {
        self.subtitleLabel.text = newText;
    }
    
    return YES;
}

- (void) bounceEffectWithView: (UIView *) view
{
    [UIView animateWithDuration:.1f animations:^{
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1f animations:^{
            view.transform = CGAffineTransformIdentity;
        }];
    }];
}
- (IBAction)selectPhoto:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profilePhoto.image = chosenImage;
    self.profilePhoto.layer.cornerRadius = self.profilePhoto.bounds.size.width/2;
    self.profilePhoto.layer.masksToBounds = YES;
    

    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        self.doctorPhoto = _profilePhoto.image;
    }
    else {
        self.userPhoto = self.profilePhoto.image;
    
    }

    
}
    
    @end

