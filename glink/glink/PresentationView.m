//
//  PresentationView.m
//  glink
//
//  Created by Federico Bustos Fierro on 7/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "PresentationView.h"

@implementation PresentationView

- (void) setUpWithPresentationItem: (PresentationItem *) item
{
    self.titleLabel.text = item.title;
}

@end
