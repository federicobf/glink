//
//  PresentiationViewController.h
//  glink
//
//  Created by Federico Bustos Fierro on 7/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentationItem.h"

@interface PresentiationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) PresentationItem *presentationItem;
@end
