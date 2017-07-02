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
- (void) setUpWithPresentationItem: (PresentationItem *) item;
@end
