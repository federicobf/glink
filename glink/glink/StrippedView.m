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
    
    for (int x = 0; x < 101; x++) {
        
        float height = 45;
        float position = 60;
        float widht = 1.1;
        
        if (!(x % 5)) {
            position = 40;
            widht = 2;
            height = 66;
            
        }
        
        UIView *line = [UIView new];
        float posx = -300 + 15 * x;
        line.frame = CGRectMake(posx, position , widht, height);
        line.backgroundColor = [UIColor colorWithRed:24/255.f green:23/255.f blue:23/255.f alpha:.1f];
        
        [self addSubview:line];
    }
}


@end
