//
//  FakeStatisticCell.m
//  glink
//
//  Created by Federico Bustos Fierro on 8/1/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "FakeStatisticCell.h"

@implementation FakeStatisticCell

- (UIColor *) innerColor
{
    return self.fillColor;
}

- (UIColor *) strongColor
{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    if (!self.fillColor) {
        return [UIColor blackColor];
    }
    
    if ([self.fillColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self.fillColor getRed:&red green:&green blue:&blue alpha:&alpha];
    } else {
        const CGFloat *components = CGColorGetComponents(self.fillColor.CGColor);
        red = components[0];
        green = components[1];
        blue = components[2];
        alpha = components[3];
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

- (NSArray *) helpersX
{
    return @[];
}

@end
