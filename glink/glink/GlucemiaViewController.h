//
//  GlucemiaViewController.h
//  glink
//
//  Created by Federicuelo on 15/4/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrippedView.h"

@interface GlucemiaViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property CGFloat initialValue;
@property (weak, nonatomic) IBOutlet StrippedView *strippedView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
