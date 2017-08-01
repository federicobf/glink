//
//  PresentationView.h
//  glink
//
//  Created by Federico Bustos Fierro on 7/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentationItem.h"

@interface PresentationView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *gds;
@property (weak, nonatomic) IBOutlet UILabel *gas;
@property (weak, nonatomic) IBOutlet UILabel *gms;
@property (weak, nonatomic) IBOutlet UILabel *gcs;
@property (weak, nonatomic) IBOutlet UILabel *gdm;
@property (weak, nonatomic) IBOutlet UILabel *gam;
@property (weak, nonatomic) IBOutlet UILabel *gmm;
@property (weak, nonatomic) IBOutlet UILabel *gcm;
@property (weak, nonatomic) IBOutlet UILabel *gdt;
@property (weak, nonatomic) IBOutlet UILabel *gat;
@property (weak, nonatomic) IBOutlet UILabel *gmt;
@property (weak, nonatomic) IBOutlet UILabel *gct;

@property (weak, nonatomic) IBOutlet UILabel *cds;
@property (weak, nonatomic) IBOutlet UILabel *cas;
@property (weak, nonatomic) IBOutlet UILabel *cms;
@property (weak, nonatomic) IBOutlet UILabel *ccs;
@property (weak, nonatomic) IBOutlet UILabel *cdm;
@property (weak, nonatomic) IBOutlet UILabel *cam;
@property (weak, nonatomic) IBOutlet UILabel *cmm;
@property (weak, nonatomic) IBOutlet UILabel *ccm;
@property (weak, nonatomic) IBOutlet UILabel *cdt;
@property (weak, nonatomic) IBOutlet UILabel *cat;
@property (weak, nonatomic) IBOutlet UILabel *cmt;
@property (weak, nonatomic) IBOutlet UILabel *cct;

@property (weak, nonatomic) IBOutlet UILabel *ids;
@property (weak, nonatomic) IBOutlet UILabel *ias;
@property (weak, nonatomic) IBOutlet UILabel *ims;
@property (weak, nonatomic) IBOutlet UILabel *ics;
@property (weak, nonatomic) IBOutlet UILabel *idm;
@property (weak, nonatomic) IBOutlet UILabel *iam;
@property (weak, nonatomic) IBOutlet UILabel *imm;
@property (weak, nonatomic) IBOutlet UILabel *icm;
@property (weak, nonatomic) IBOutlet UILabel *idt;
@property (weak, nonatomic) IBOutlet UILabel *iat;
@property (weak, nonatomic) IBOutlet UILabel *imt;
@property (weak, nonatomic) IBOutlet UILabel *ict;

@property (weak, nonatomic) IBOutlet UIView *glucemiaContainer;
@property (weak, nonatomic) IBOutlet UIView *carbsContainer;
@property (weak, nonatomic) IBOutlet UIView *insulinaContainer;

- (void) setUpWithPresentationItem: (PresentationItem *) item;
@end
