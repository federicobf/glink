//
//  StrippedView.m
//  glink
//
//  Created by Federicuelo on 15/4/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "StrippedView.h"

@implementation StrippedView

- (void) drawLines
{
    
    for (int x = 0; x < 100; x++) {
        
        
        float position = 60;
        
        if (!(x % 5)) {
            position = 40;
        }
        
        if (!(x % 20)) {
            position = 20;
        }
        
        UIView *line = [UIView new];
        line.frame = CGRectMake(13 * x , position , 5, 100);
        line.backgroundColor = [UIColor colorWithRed:24/255.f green:23/255.f blue:23/255.f alpha:.1f];
        
        [self addSubview:line];
    }
}


@end
