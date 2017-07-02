//
//  CurveView.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/23/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "CurveView.h"

@implementation CurveView

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.myPoints = [NSMutableArray new];
    
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    }
    
    return self;

}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGAffineTransform t0 = CGContextGetCTM(context);
    t0 = CGAffineTransformInvert(t0);
    CGContextConcatCTM(context, t0);
    
    //Begin drawing setup
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    CGContextSetLineWidth(context, 2.0);

    //Start drawing polygon

    CGFloat firstStep = [[self.externalPoints firstObject] CGPointValue].y;
    CGFloat lastStep = [[self.externalPoints lastObject] CGPointValue].y;
    
    [self.myPoints addObject:[NSValue valueWithCGPoint:CGPointMake(0, -200)]];
    [self.myPoints addObject:[NSValue valueWithCGPoint:CGPointMake(-200, firstStep)]];
    [self.myPoints addObject:[NSValue valueWithCGPoint:CGPointMake(0, firstStep)]];

    [self.myPoints addObjectsFromArray:self.externalPoints];
    
    [self.myPoints addObject:[NSValue valueWithCGPoint:CGPointMake(self.frame.size.width*2,lastStep)]];
    [self.myPoints addObject:[NSValue valueWithCGPoint:CGPointMake(self.frame.size.width*2+200, lastStep)]];
    [self.myPoints addObject:[NSValue valueWithCGPoint:CGPointMake(self.frame.size.width*2,-200)]];

    
#define SMOOTHNESS 20
    
    for(NSUInteger i = 0; i <= self.myPoints.count; ++i) {
        CGPoint p0 = [self.myPoints[(i + 0) % self.myPoints.count] CGPointValue];
        CGPoint p1 = [self.myPoints[(i + 1) % self.myPoints.count] CGPointValue];
        CGPoint p2 = [self.myPoints[(i + 2) % self.myPoints.count] CGPointValue];
        CGPoint p3 = [self.myPoints[(i + 3) % self.myPoints.count] CGPointValue];
        
        for(CGFloat t = 0; t <= 1; t += 1.0 / SMOOTHNESS) {
            CGFloat t2 = t*t, t3 = t * t * t;
            CGFloat x = 0.5 *((2 * p1.x) + (-p0.x + p2.x) * t + (2*p0.x - 5*p1.x + 4*p2.x - p3.x) * t2 + (-p0.x + 3*p1.x- 3*p2.x + p3.x) * t3);
            CGFloat y = 0.5 *((2 * p1.y) + (-p0.y + p2.y) * t + (2*p0.y - 5*p1.y + 4*p2.y - p3.y) * t2 + (-p0.y + 3*p1.y- 3*p2.y + p3.y) * t3);
            
            if(i == 0 && t == 0)
                CGContextMoveToPoint(context, x, y);
            else
                CGContextAddLineToPoint(context, x, y);
        }
    }
    
    CGColorRef color = [self.internalColor CGColor];
    
    if (CGColorGetNumberOfComponents(color) == 4)
    {
        const CGFloat *components = CGColorGetComponents(color);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        CGFloat alpha = components[3];
        
        CGContextSetRGBFillColor(context, red, green, blue, alpha);
        CGContextSetRGBStrokeColor (context, 0,0,0,1);
        CGContextSetLineWidth (context, 2);
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1].CGColor);
    }

    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
}
@end
