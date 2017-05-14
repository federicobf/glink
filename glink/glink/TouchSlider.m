//
//  TouchSlider.m
//  glink
//
//  Created by Federico Bustos Fierro on 5/14/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "TouchSlider.h"

@implementation TouchSlider

//- (CGRect)thumbRect
//{
//    CGRect trackRect = [self trackRectForBounds:self.bounds];
//    CGRect thumbRect = [self thumbRectForBounds:self.bounds
//                                      trackRect:trackRect
//                                          value:self.value];
//    return thumbRect;
//}
//
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    CGRect thumbFrame = [self thumbRect];
//    
//    // check if the point is within the thumb
////    if (CGRectContainsPoint(thumbFrame, point))
////    {
//        // if so trigger the method of the super class
//        NSLog(@"inside thumb");
//        return [super hitTest:point withEvent:event];
////    }
////    else
////    {
////        // if not just pass the event on to your superview
////        NSLog(@"outside thumb");
////        return [[self superview] hitTest:point withEvent:event];
////    }
//}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -10, -15);
    return CGRectContainsPoint(bounds, point);
}

@end
