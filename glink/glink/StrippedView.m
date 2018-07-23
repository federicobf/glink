//
//  StrippedView.m
//  glink
//
//  Created by Federicuelo on 15/4/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "StrippedView.h"
#import "HealthManager.h"


@implementation StrippedView

- (void) drawLines
{
    if (self.drawnLines) {
        return;
    }
    
    self.drawnLines = YES;
    
    for (int x = 0; x < 161; x++) {
        
        float altura = self.frame.size.height;

        float widht;
        float height;
        float position;
        
        if (!(x % 5)) {
            //barritas altas
            widht = 1.5f;
            height = 66;
            position = altura - height;
            
        } else {
            //barritas bajas
            widht = .5f;
            height = 45;
            position = altura - height - 11;
    

        }
        
        UIView *line = [UIView new];
        float posx = -300 + 60 * x -1.f;
        line.frame = CGRectMake(posx, position , widht, height);

        
        float numeroActual = posx / 12;
        
        if (numeroActual < [self minRed] || numeroActual > [self maxRed]) {
            line.backgroundColor = [UIColor colorWithRed:1 green:.2f blue:.2f alpha:.3f];
        } else {
            line.backgroundColor = [UIColor colorWithRed:24/255.f green:23/255.f blue:23/255.f alpha:.2f];
        }
        
        [self addSubview:line];
    }
}

- (CGFloat) minRed {
    return kHipoGlucemia;
}

- (CGFloat) maxRed {
    return kHiperGlucemia;
}


@end
