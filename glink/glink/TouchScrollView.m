//
//  TouchScrollView.m
//  glink
//
//  Created by Federico Bustos Fierro on 5/13/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "TouchScrollView.h"

@implementation TouchScrollView

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    if ([view isKindOfClass:[UISlider class]]) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:view];
        CGRect thumbRect;
        UISlider *mySlide = (UISlider*) view;
        CGRect trackRect = [mySlide trackRectForBounds:mySlide.bounds];
        thumbRect = [mySlide thumbRectForBounds:mySlide.bounds trackRect:trackRect value:mySlide.value];
        if (CGRectContainsPoint(thumbRect, location))
            return YES;
    }
    return NO;
}

@end
