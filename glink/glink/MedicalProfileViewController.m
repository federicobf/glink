//
//  MedicalProfileViewController.m
//  glink
//
//  Created by Federicuelo on 28/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "MedicalProfileViewController.h"
#import "MedicalProfileTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>

@interface MedicalProfileViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate>
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
    self.profilePhoto.backgroundColor = [UIColor whiteColor];
    
    NSData* imageDataMedico = [[NSUserDefaults standardUserDefaults] objectForKey:@"Foto-Medico"];
    UIImage* imageMedico = [UIImage imageWithData:imageDataMedico];
    self.doctorPhoto = (imageMedico != nil) ? imageMedico : [UIImage imageNamed:@"profileimage"];
    
    
    NSData* imageDataPaciente = [[NSUserDefaults standardUserDefaults] objectForKey:@"Foto-Paciente"];
    UIImage* imagePaciente = [UIImage imageWithData:imageDataPaciente];
    self.userPhoto = (imagePaciente != nil) ? imagePaciente : [UIImage imageNamed:@"profileimage"];
    
    self.profilePhoto.image = self.userPhoto;
    
    self.profilePhoto.layer.cornerRadius = self.profilePhoto.bounds.size.width/2;
    self.profilePhoto.layer.masksToBounds = YES;
    
    [self updateWithSavedData];
    
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
    [self updateWithSavedData];
    self.profilePhoto.layer.cornerRadius = self.profilePhoto.bounds.size.width/2;
    self.profilePhoto.layer.masksToBounds = YES;
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
        cell.cellTextField.keyboardType = UIKeyboardTypeEmailAddress;
        [cell.cellButton setTitle:@"ENVIAR MAIL" forState:UIControlStateNormal];
        cell.cellTextField.tag = 201;
        
    }
    
    if (indexPath.row == 1) {
        cell.cellLabel.text = @"Teléfono";
        cell.cellTextField.keyboardType = UIKeyboardTypePhonePad;
        [cell.cellButton setTitle:@"LLAMAR" forState:UIControlStateNormal];
        cell.cellTextField.tag = 202;
    }
    
    if (indexPath.row == 2) {
        cell.cellLabel.text = @"Web";
        [cell.cellButton setTitle:@"ENTRAR" forState:UIControlStateNormal];
        cell.cellTextField.keyboardType = UIKeyboardTypeURL;
        cell.cellTextField.tag = 203;
    }
    
    if (indexPath.row == 3) {
        cell.cellLabel.text = @"Ubicación";
        cell.cellTextField.keyboardType = UIKeyboardTypeDefault;
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
        [self sendEmailTo:cell.cellTextField.text];
    }
    
    if (indexPath.row == 1) {
        
        NSString *stringPath = [NSString stringWithFormat:@"telprompt://%@", cell.cellTextField.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringPath]];
    }
    
    if (indexPath.row == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: cell.cellTextField.text]];
        
    }
    
    if (indexPath.row == 3) {
        [self openMapsWithAddress: cell.cellTextField.text];
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
        cell.cellTextField.keyboardType = UIKeyboardTypeDefault;
        cell.cellTextField.tag = 102;
    }
    
    if (indexPath.row == 2) {
        cell.cellLabel.text = @"Web";
        [cell.cellButton setTitle:@"" forState:UIControlStateNormal];
        cell.cellTextField.keyboardType = UIKeyboardTypeURL;
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

- (void) updateWithSavedData
{
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self showSavedDataForPaciente];
    } else {
        [self showSavedDataForMedico];
    }
}

- (void) showSavedDataForPaciente
{
    self.titleLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"Paciente-Title"];
    self.subtitleLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"Paciente-Subtitle"];
}


- (void) showSavedDataForMedico
{
    self.titleLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"Medico-Title"];
    self.subtitleLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"Medico-Subtitle"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.fakeTitleTextfield && self.segmentedControl.selectedSegmentIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"Paciente-Title"];
        return;
    }
    
    if (textField == self.fakeTitleTextfield && self.segmentedControl.selectedSegmentIndex == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"Medico-Title"];
        return;
    }
    
    if (textField == self.fakeSubtitleTextfield && self.segmentedControl.selectedSegmentIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"Paciente-Subtitle"];
        return;
    }
    
    if (textField == self.fakeSubtitleTextfield && self.segmentedControl.selectedSegmentIndex == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"Medico-Subtitle"];
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

    

    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        self.doctorPhoto = self.profilePhoto.image;
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(chosenImage) forKey:@"Foto-Medico"];
    }
    else {
        self.userPhoto = self.profilePhoto.image;
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(chosenImage) forKey:@"Foto-Paciente"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) sendEmailTo: (NSString *) recipient
{
    // Email Subject
    NSString *emailTitle = @"Consulta medica";
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

- (IBAction)openMapsWithAddress: (NSString *) address
{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     
                     // Convert the CLPlacemark to an MKPlacemark
                     // Note: There's no error checking for a failed geocode
                     CLPlacemark *geocodedPlacemark = [placemarks objectAtIndex:0];
                     MKPlacemark *placemark = [[MKPlacemark alloc]
                                               initWithCoordinate:geocodedPlacemark.location.coordinate
                                               addressDictionary:geocodedPlacemark.addressDictionary];
                     
                     // Create a map item for the geocoded address to pass to Maps app
                     MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                     [mapItem setName:geocodedPlacemark.name];
                     
                     // Set the directions mode to "Driving"
                     // Can use MKLaunchOptionsDirectionsModeWalking instead
                     NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
                     
                     // Get the "Current User Location" MKMapItem
                     MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
                     
                     // Pass the current location and destination map items to the Maps app
                     // Set the direction mode in the launchOptions dictionary
                     [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
                     
                 }];
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

