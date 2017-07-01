//
//  MedicalProfileTableViewCell.h
//  glink
//
//  Created by Federicuelo on 28/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicalProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UITextField *cellTextField;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *cellButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (strong, nonatomic) NSIndexPath *indexPath;


@end
