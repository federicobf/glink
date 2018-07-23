//
//  StatisticsTableViewCell.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/17/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "StatisticsTableViewCell.h"
#import "PureLayout.h"
#import "HealthManager.h"
#import "CurveView.h"
#import "glink-Swift.h"

@implementation StatisticsTableViewCell {
    NSMutableArray* allDots;
    UIImageView * imageView;
    CurveView *curveView;
    HealthDayDTO *healthDayDTO;
}

- (id) init {
    
    self = [super init];
    
    if (self) {
        allDots = [NSMutableArray new];
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        self.limitsOn = YES;
    }
    
    return self;
    
}


- (void) spaceUpItemsWithType: (NSNumber*) number {

    dispatch_async(dispatch_get_main_queue(), ^{

    
        NSInteger type = [number integerValue];
        
        NSMutableArray* points = [NSMutableArray new];
        for (UIView* currentView in allDots) {
            
            if (currentView.tag == type) {
                CGPoint point = currentView.center;
                CGFloat multiplier = [UIScreen mainScreen].scale;
                point = CGPointMake(point.x*multiplier,140*multiplier - point.y*multiplier);
                [points addObject:[NSValue valueWithCGPoint:point]];
                
            }
        }
        
        NSArray *sortedArray;
        sortedArray = [points sortedArrayUsingComparator:^NSComparisonResult(NSValue* a, NSValue* b) {

            CGPoint pointA = [a CGPointValue];
            CGPoint pointB = [b CGPointValue];
            return pointA.x>pointB.x;
        }];
        
        NSLog(@"frame?? %f, %f", self.frame.size.width, self.frame.size.height);
        curveView = [[CurveView alloc] initForAutoLayout];
        [self addSubview:curveView];
        [curveView autoPinEdgesToSuperviewEdges];
        curveView.internalColor = [self innerColor];
        curveView.externalPoints = [NSMutableArray arrayWithArray:sortedArray];

        [self sendSubviewToBack:curveView];
        
    });
    
}

- (UIColor *) innerColor
{
    return [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:.05f];
}

- (UIColor *) strongColor
{
    return [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
}


- (void) configureWithHealthDay: (HealthDayDTO*) day {

    healthDayDTO = day;
    [self createDrawPoints:day.healthItems withType: (int) self.type];
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grid5"]];
    [self addSubview:imageView];
    [imageView autoPinEdgesToSuperviewEdges];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.alpha = .2f;
    [self addHelpers];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHelp)];
    [self addGestureRecognizer:gesture];
    
}

- (void) showHelp
{
    UIColor *bgColor = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *textColor = [UIColor whiteColor];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"hh:mm a"];
    
    NSString *description = @"Estos son los registros del dia:";
    for (HealthDTO *item in healthDayDTO.healthItems) {
        
        NSString *hora = [formatter stringFromDate:item.date];
        description = [NSString stringWithFormat:@"%@\n%@: G:%.0f - CH:%.0f - In:%.2f",description, hora, item.glucemia, item.carbohidratos, item.insulina];
    }
    
    
    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Registro diario" message:description alertType:AlertTypeMultipleChoice];
    
    [alert addButton:@"Continuar" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
    }];
    
    [alert addButton:@"Borrar entrada" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
        [self deleteEntry];
    }];
    
    [alert show];
}

- (void) deleteEntry
{
    UIColor *bgColor = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *textColor = [UIColor whiteColor];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"hh:mm a"];
    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Borrar entrada" message:@"Seleccione la entrada que deseas borrar" alertType:AlertTypeMultipleChoice];
    

    for (HealthDTO *item in healthDayDTO.healthItems) {
        NSString *hora = [formatter stringFromDate:item.date];
        NSString *description = [NSString stringWithFormat:@"%@", hora];
        [alert addButton:description color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
            [alertview dismissAlertView];
            BOOL success = [[HealthManager sharedInstance] deleteObject:item];
            if (success) {
                [self alertClearFinishWithTitle:@"Entrada borrada" message:description];
            } else {
                [self alertClearFinishWithTitle:@"Entrada no borrada" message:@"Algo falló borrando la entrada, intente nuevamente más tarde."];
            }
        }];

    }
    
    [alert addButton:@"Ninguna" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
    }];
    
    [alert show];
}

- (void) alertClearFinishWithTitle: (NSString *) title message: (NSString *) message
{
    UIColor *bgColor = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *textColor = [UIColor whiteColor];

    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:title message:message alertType:AlertTypeMultipleChoice];
    [alert addButton:@"De acuerdo" color:bgColor titleColor:textColor touchHandler:^(ZAlertView * _Nonnull alertview) {
        [alertview dismissAlertView];
    }];
    
    [alert show];

}

- (void) addHelpers {
    
    ///GLUCEMIA OK BARRA GRIS
    if (self.type == 0) {
        
        UIView* glucemiaOk = [[UIView alloc] initForAutoLayout];
        [self addSubview:glucemiaOk];
        [glucemiaOk autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [glucemiaOk autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        glucemiaOk.backgroundColor = [UIColor colorWithRed:.8f green:.8f blue:.8f alpha:.1f];
        
        CGFloat centerGlucemia = ((kMinGlucemiaOK - kMinGlucemia) + ((kMaxGlucemiaOK - kMinGlucemiaOK) / 2)) / (kMaxStatGlucemia - kMinGlucemia);
        CGFloat heightRatioGlucemia = (kMaxGlucemiaOK - kMinGlucemiaOK) / (kMaxStatGlucemia - kMinGlucemia);
        
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:glucemiaOk
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier: (2 - 2* centerGlucemia)
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:glucemiaOk
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier: heightRatioGlucemia
                                                             constant:0],
                               ]
         ];
        
    }
    
    UIView *inferiorBorder = [[UIView alloc] initForAutoLayout];
    inferiorBorder.backgroundColor = [UIColor whiteColor];
    inferiorBorder.alpha = .5f;
    [self addSubview:inferiorBorder];
    [inferiorBorder autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
    [inferiorBorder autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [inferiorBorder autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [inferiorBorder autoSetDimension:ALDimensionHeight toSize:16.0f];
    
    
    NSArray* helpersX = [self helpersX];
    CGFloat count = 0;
    for (NSString* str in helpersX) {

        count++;
        
        CGFloat multiplier = (count/(helpersX.count-1));
        multiplier = 0.25f/(helpersX.count-1) + 5.0f/6.0f * multiplier;
        UILabel* label = [[UILabel alloc] initForAutoLayout];
        [self addSubview:label];
        label.text = str;
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        [label setFont:[UIFont systemFontOfSize:10]];
        [label autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:[UIScreen mainScreen].bounds.size.width * multiplier];
    }
    
    NSMutableArray* helpersY = [NSMutableArray new];
    
    if (self.type == 0) {
    
        for (int x = 0; x < 6; x++) {
           
            CGFloat currentValue = ((kMaxStatGlucemia - kMinGlucemia)* x/5.0f)+kMinGlucemia;
            [helpersY addObject:[NSString stringWithFormat:@"%i", (int) currentValue]];
            
        }
    
    }
    
    if (self.type == 1) {
        
        for (int x = 0; x < 6; x++) {
            
            CGFloat currentValue = ((kMaxStatCH - kMinCH)* x/5.0f)+kMinCH;
            [helpersY addObject:[NSString stringWithFormat:@"%i", (int) currentValue]];
            
        }
        
    }
    
    if (self.type == 2) {
        
        for (int x = 0; x < 6; x++) {
            
            CGFloat currentValue = ((kMaxStatInsulina - kMinInsulina)* x/5.0f)+kMinInsulina;
            [helpersY addObject:[NSString stringWithFormat:@"%i", (int) currentValue]];
            
        }
        
    }

    UIView *whiteBorder = [[UIView alloc] initForAutoLayout];
    whiteBorder.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteBorder];
    [whiteBorder autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];
    [whiteBorder autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [whiteBorder autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [whiteBorder autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self withMultiplier:1.0f/12.0f];
    
    CGFloat count2 = 0;
    for (NSString* str in helpersY) {
        

        
        CGFloat multiplier = 2 - 2*(count2/(helpersY.count-1));
        if (multiplier==0) {multiplier=.1f;}
        if (multiplier==2) {multiplier=1.9f;}
        count2++;
        
        UILabel* label = [[UILabel alloc] initForAutoLayout];
        [self addSubview:label];
        label.text = str;
        [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:8];
        [label setFont:[UIFont systemFontOfSize:10]];
        
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:label
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier: multiplier
                                                             constant:0]
                               ]
         ];
        
    }
    
    


}

- (NSArray *) helpersX
{
    return @[@"12am",@"3am",@"6am",@"9am",@"12pm",@"3pm",@"6pm",@"9pm",@"12am"];
}

- (void) addTitleLabel: (HealthDayDTO*) day {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:day.date];
    NSInteger daystr = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    

    UILabel* label = [[UILabel alloc] initForAutoLayout];
    [self addSubview:label];
    label.text = [NSString stringWithFormat:@"%02ld-%02ld del %li", (long)daystr, (long)month, (long)year];
    [label autoSetDimension:ALDimensionHeight toSize:22];
    [label setFont:[UIFont systemFontOfSize:15.f]];
    label.textAlignment = NSTextAlignmentRight;
    [label autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:label.superview withOffset:-10];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:label.superview];

    
    UILabel* label2 = [[UILabel alloc] initForAutoLayout];
    [self addSubview:label2];
    label2.text = self.type==0? @"Glucemia" : self.type==1? @"Carbohidratos" : @"Vista compuesta";
    [label2 autoSetDimension:ALDimensionHeight toSize:15];
    [label2 setFont:[UIFont boldSystemFontOfSize:12.f]];
    [label2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:label2.superview withOffset:-10];
    [label2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label];
    label2.textAlignment = NSTextAlignmentRight;
    label2.textColor = self.type==0?  [UIColor colorWithRed:255/255.f green:33/255.f blue:162/255.f alpha:1] : self.type==1? [UIColor colorWithRed:155/255.f green:100/255.f blue:251/255.f alpha:1]: [UIColor magentaColor];
}

- (void) createDrawPoints: (NSMutableArray*) dtos withType: (int) type {
    
    
    for (HealthDTO* dto in dtos) {
        
        UIView* v = [[UIView new] initForAutoLayout];
        UIView* whiteCenter = [[UIView new] initForAutoLayout];
        whiteCenter.backgroundColor = [UIColor whiteColor];
        v.layer.cornerRadius = 6;
        whiteCenter.layer.cornerRadius = 3;
        v.tag = type;
        v.backgroundColor = [self strongColor];
        
        if (!(type==0 && dto.glucemia == 0) && !(type==2 && dto.insulina == 0)) {
            
            [self addSubview:v];
            [v autoSetDimensionsToSize:CGSizeMake(12, 12)];
            [whiteCenter autoSetDimensionsToSize:CGSizeMake(6, 6)];
            [v addSubview:whiteCenter];
            whiteCenter.backgroundColor = [UIColor whiteColor];
            [whiteCenter autoCenterInSuperview];
            
        CGFloat multiplierDate = (dto.date.timeIntervalSince1970 - [dto getSimpleDate].timeIntervalSince1970)/ 60/60/24;
            multiplierDate = 1.0f/6.0f + 5.0f/6.0f * multiplierDate;
        CGFloat multiplierValue;
            
            if (type==0) {
                multiplierValue = (dto.glucemia - kMinGlucemia) / (kMaxStatGlucemia - kMinGlucemia);
            } else if (type==1) {
                multiplierValue =  (dto.carbohidratos - kMinCH) / (kMaxStatCH - kMinCH);
            } else {
                multiplierValue =  (dto.insulina - kMinInsulina) / (kMaxStatInsulina - kMinInsulina);
            }
            
        if (self.limitsOn) {
            if (multiplierValue<=0) {multiplierValue=0.05f;}
            if (multiplierValue>=1) {multiplierValue=0.95f;}
        }
            
        [self addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:v
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:2-multiplierValue*2.f
                                                                  constant:0],
                                    
                                    [NSLayoutConstraint constraintWithItem:v
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual 
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:multiplierDate*2.f
                                                                  constant:0]
                                    ]];
            

            [allDots addObject:v];
        }
            
        }
        
        [self setNeedsUpdateConstraints];
        [self layoutIfNeeded];
        [self spaceUpItemsWithType:[NSNumber numberWithInt:type]];
    
}

@end
