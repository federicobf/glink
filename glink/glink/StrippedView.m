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
    
    for (int x = 0; x < 161; x++) {
        
        float altura = self.frame.size.height;

        float widht;
        float height;
        float position;
        
        if (!(x % 5)) {
            //barritas altas
            widht = 2;
            height = 66;
            position = altura - height;
            
        } else {
            //barritas bajas
            widht = 1.1;
            height = 45;
            position = altura - height - 11;
    

        }
        
        UIView *line = [UIView new];
        float posx = -300 + 15 * x -.5f;
        line.frame = CGRectMake(posx, position , widht, height);

        
        float numeroActual = posx / 3;
        
        if (numeroActual < 70 || numeroActual > 300) {
            line.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.4f];
        } else {
            line.backgroundColor = [UIColor colorWithRed:24/255.f green:23/255.f blue:23/255.f alpha:.1f];
        }
        
        [self addSubview:line];
    }
}


@end
