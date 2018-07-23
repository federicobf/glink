//
//  PresentationView.m
//  glink
//
//  Created by Federico Bustos Fierro on 7/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "PresentationView.h"
#import "HealthManager.h"
#import "FakeStatisticCell.h"
#import "PureLayout.h"

@implementation PresentationView

- (void) setUpWithPresentationItem: (PresentationItem *) item
{
    self.titleLabel.text = item.title;
    [self loadGlucemiaData];
    [self loadCarbsData];
    [self loadInsulinaData];
    //[self drawCellIntoView:self.glucemiaContainer withItems:@[self.gds, self.gas, self.gms, self.gcs] andType:0];
    self.glucemiaContainer.backgroundColor = [UIColor whiteColor];
    [self drawCellIntoView:self.glucemiaContainer withItems:@[self.gdt, self.gat, self.gmt, self.gct] andType:0 andColor:[self greenColor]];
    [self drawCellIntoView:self.glucemiaContainer withItems:@[self.gdm, self.gam, self.gmm, self.gcm] andType:0 andColor:[self blueColor]];
    [self drawCellIntoView:self.glucemiaContainer withItems:@[self.gds, self.gas, self.gms, self.gcs] andType:0 andColor:[self orangeColor]];
    
    self.carbsContainer.backgroundColor = [UIColor whiteColor];
    [self drawCellIntoView:self.carbsContainer withItems:@[self.cdt, self.cat, self.cmt, self.cct] andType:1 andColor:[self greenColor]];
    [self drawCellIntoView:self.carbsContainer withItems:@[self.cdm, self.cam, self.cmm, self.ccm] andType:1 andColor:[self blueColor]];
    [self drawCellIntoView:self.carbsContainer withItems:@[self.cds, self.cas, self.cms, self.ccs] andType:1 andColor:[self orangeColor]];
    
    self.insulinaContainer.backgroundColor = [UIColor whiteColor];
    [self drawCellIntoView:self.insulinaContainer withItems:@[self.idt, self.iat, self.imt, self.ict] andType:2 andColor:[self greenColor]];
    [self drawCellIntoView:self.insulinaContainer withItems:@[self.idm, self.iam, self.imm, self.icm] andType:2 andColor:[self blueColor]];
    [self drawCellIntoView:self.insulinaContainer withItems:@[self.ids, self.ias, self.ims, self.ics] andType:2 andColor:[self orangeColor]];

}

- (UIColor *) greenColor
{
    return [UIColor colorWithRed:.2f green:1 blue:0 alpha:.0f];
}
- (UIColor *) orangeColor
{
    return [UIColor colorWithRed:1 green:.5f blue:0 alpha:.0f];
}
- (UIColor *) blueColor
{
    return [UIColor colorWithRed:0 green:.5f blue:1 alpha:.0f];
}

- (void) drawCellIntoView: (UIView *) containerView withItems: (NSArray <UILabel *> *)items andType: (NSInteger) type andColor: (UIColor *) fillColor;
{
    
    FakeStatisticCell *innerCell = [[FakeStatisticCell alloc] init];
    [containerView addSubview:innerCell];
    [innerCell autoPinEdgesToSuperviewEdges];
    innerCell.type = type;
    innerCell.fillColor = fillColor;
    innerCell.limitsOn = YES;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    HealthDayDTO* newDay = [HealthDayDTO new];
    [formatter setDateFormat: @"HH:mm"];
    int value = 3;
    for (UILabel * label in items) {
        
        CGFloat floatvalue = [label.text isEqualToString: @"-"]? [self minimumForType:type] : label.text.floatValue;
        
        HealthDTO* dto = [HealthDTO new];
        dto.carbohidratos = floatvalue;
        dto.glucemia = floatvalue;;
        dto.insulina = floatvalue;;
        
        dto.date = [formatter dateFromString:[NSString stringWithFormat:@"%02d:00",value]];
        value += 6;
        
        [newDay.healthItems addObject:dto];
    }
    
    newDay.date = [NSDate date];
    
    [innerCell configureWithHealthDay:newDay];
    innerCell.clipsToBounds = NO;
    innerCell.backgroundColor = [UIColor clearColor];
}

- (NSInteger) minimumForType: (NSInteger) type
{
    switch (type) {
        case 0: return -30.0f;
        case 1: return -30.0f;
        case 2: return -5.0f;
        default: return 0;
    }
}

- (NSArray *) labelsArray
{
    return @[self.gds, self.gas, self.gms, self.gcs, self.gdm, self.gam, self.gmm, self.gcm, self.gdt, self.gat, self.gmt, self.gct, self.cds, self.cas, self.cms, self.ccs, self.cdm, self.cam, self.cmm, self.ccm, self.cdt, self.cat, self.cmt, self.cct,self.ids, self.ias, self.ims, self.ics, self.idm, self.iam, self.imm, self.icm, self.idt, self.iat, self.imt, self.ict];
}

- (void) checkFields
{
    for (UILabel* lbl in [self labelsArray]) {
        lbl.font = [UIFont systemFontOfSize:9];
        if ([lbl.text isEqualToString:@"nan"]) {
            lbl.text = @"-";
        }
    }
    
}


- (void) loadGlucemiaData {
    
    self.gds.text    = [self sumUpGlucemia:[self filterItemsForDesayuno:[self allWeekItems]]];
    self.gdm.text    = [self sumUpGlucemia:[self filterItemsForDesayuno:[self allMonthItems]]];
    self.gdt.text    = [self sumUpGlucemia:[self filterItemsForDesayuno:[self allTrimesterItems]]];
    
    self.gas.text    = [self sumUpGlucemia:[self filterItemsForAlmuerzo:[self allWeekItems]]];
    self.gam.text    = [self sumUpGlucemia:[self filterItemsForAlmuerzo:[self allMonthItems]]];
    self.gat.text    = [self sumUpGlucemia:[self filterItemsForAlmuerzo:[self allTrimesterItems]]];
    
    self.gms.text    = [self sumUpGlucemia:[self filterItemsForMerienda:[self allWeekItems]]];
    self.gmm.text    = [self sumUpGlucemia:[self filterItemsForMerienda:[self allMonthItems]]];
    self.gmt.text    = [self sumUpGlucemia:[self filterItemsForMerienda:[self allTrimesterItems]]];
    
    self.gcs.text    = [self sumUpGlucemia:[self filterItemsForCena:[self allWeekItems]]];
    self.gcm.text    = [self sumUpGlucemia:[self filterItemsForCena:[self allMonthItems]]];
    self.gct.text    = [self sumUpGlucemia:[self filterItemsForCena:[self allTrimesterItems]]];
    
    [self checkFields];
}

- (void) loadCarbsData {
    
    self.cds.text    = [self sumUpCarbohidratos:[self filterItemsForDesayuno:[self allWeekItems]]];
    self.cdm.text    = [self sumUpCarbohidratos:[self filterItemsForDesayuno:[self allMonthItems]]];
    self.cdt.text    = [self sumUpCarbohidratos:[self filterItemsForDesayuno:[self allTrimesterItems]]];
    
    self.cas.text    = [self sumUpCarbohidratos:[self filterItemsForAlmuerzo:[self allWeekItems]]];
    self.cam.text    = [self sumUpCarbohidratos:[self filterItemsForAlmuerzo:[self allMonthItems]]];
    self.cat.text    = [self sumUpCarbohidratos:[self filterItemsForAlmuerzo:[self allTrimesterItems]]];
    
    self.cms.text    = [self sumUpCarbohidratos:[self filterItemsForMerienda:[self allWeekItems]]];
    self.cmm.text    = [self sumUpCarbohidratos:[self filterItemsForMerienda:[self allMonthItems]]];
    self.cmt.text    = [self sumUpCarbohidratos:[self filterItemsForMerienda:[self allTrimesterItems]]];
    
    self.ccs.text    = [self sumUpCarbohidratos:[self filterItemsForCena:[self allWeekItems]]];
    self.ccm.text    = [self sumUpCarbohidratos:[self filterItemsForCena:[self allMonthItems]]];
    self.cct.text    = [self sumUpCarbohidratos:[self filterItemsForCena:[self allTrimesterItems]]];
    
    [self checkFields];
}

- (void) loadInsulinaData {
    
    self.ids.text    = [self sumUpInsulina:[self filterItemsForDesayuno:[self allWeekItems]]];
    self.idm.text    = [self sumUpInsulina:[self filterItemsForDesayuno:[self allMonthItems]]];
    self.idt.text    = [self sumUpInsulina:[self filterItemsForDesayuno:[self allTrimesterItems]]];
    
    self.ias.text    = [self sumUpInsulina:[self filterItemsForAlmuerzo:[self allWeekItems]]];
    self.iam.text    = [self sumUpInsulina:[self filterItemsForAlmuerzo:[self allMonthItems]]];
    self.iat.text    = [self sumUpInsulina:[self filterItemsForAlmuerzo:[self allTrimesterItems]]];
    
    self.ims.text    = [self sumUpInsulina:[self filterItemsForMerienda:[self allWeekItems]]];
    self.imm.text    = [self sumUpInsulina:[self filterItemsForMerienda:[self allMonthItems]]];
    self.imt.text    = [self sumUpInsulina:[self filterItemsForMerienda:[self allTrimesterItems]]];
    
    self.ics.text    = [self sumUpInsulina:[self filterItemsForCena:[self allWeekItems]]];
    self.icm.text    = [self sumUpInsulina:[self filterItemsForCena:[self allMonthItems]]];
    self.ict.text    = [self sumUpInsulina:[self filterItemsForCena:[self allTrimesterItems]]];
    
    [self checkFields];
}






- (NSString *) sumUpInsulina: (NSMutableArray*) items {
    NSMutableArray *numberArray = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if (dto.insulina != 0) {
            [numberArray addObject:[NSNumber numberWithFloat:dto.insulina]];
        }
    }
    NSArray *newArray = numberArray.copy;
    if (newArray.count == 0){
        return @"-";
    }
    
    NSNumber *average = [self calculateStat:@"average" forArray:newArray];
    NSNumber *stdev = [self calculateStat:@"stddev" forArray:newArray];
    return [NSString stringWithFormat:@"%.2f±%.2f",average.floatValue, stdev.floatValue];
}

- (NSString *) sumUpGlucemia: (NSMutableArray*) items {
    NSMutableArray *numberArray = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if (dto.glucemia != 0) {
            [numberArray addObject:[NSNumber numberWithFloat:dto.glucemia]];
        }
    }
    NSArray *newArray = numberArray.copy;
    if (newArray.count == 0){
        return @"-";
    }
    
    NSNumber *average = [self calculateStat:@"average" forArray:newArray];
    NSNumber *stdev = [self calculateStat:@"stddev" forArray:newArray];
    return [NSString stringWithFormat:@"%.1f±%.1f",average.floatValue, stdev.floatValue];
}

- (NSString *) sumUpCarbohidratos: (NSMutableArray*) items {
    NSMutableArray *numberArray = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if (dto.carbohidratos != 0) {
            [numberArray addObject:[NSNumber numberWithFloat:dto.carbohidratos]];
        }
    }
    NSArray *newArray = numberArray.copy;
    if (newArray.count == 0){
        return @"-";
    }
    
    NSNumber *average = [self calculateStat:@"average" forArray:newArray];
    NSNumber *stdev = [self calculateStat:@"stddev" forArray:newArray];
    return [NSString stringWithFormat:@"%.1f±%.1f",average.floatValue, stdev.floatValue];
}


- (NSNumber *)calculateStat:(NSString *)stat forArray: (NSArray *) array
{
    NSArray *args = @[[NSExpression expressionForConstantValue:array]];
    NSString *statFormatted = [stat stringByAppendingString:@":"];
    NSExpression *expression = [NSExpression expressionForFunction:statFormatted arguments:args];
    return [expression expressionValueWithObject:nil context:nil];
}


- (NSMutableArray*) filterItemsForDesayuno: (NSMutableArray*) items {
    
    NSMutableArray* hourItems = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if ([self timeframeForDate:dto.date]==1) {
            [hourItems addObject:dto];
        }
    }
    return hourItems;
}

- (NSMutableArray*) filterItemsForAlmuerzo: (NSMutableArray*) items {
    
    NSMutableArray* hourItems = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if ([self timeframeForDate:dto.date]==2) {
            [hourItems addObject:dto];
        }
    }
    return hourItems;
}

- (NSMutableArray*) filterItemsForMerienda: (NSMutableArray*) items {
    
    NSMutableArray* hourItems = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if ([self timeframeForDate:dto.date]==3) {
            [hourItems addObject:dto];
        }
    }
    return hourItems;
}

- (NSMutableArray*) filterItemsForCena: (NSMutableArray*) items {
    
    NSMutableArray* hourItems = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if ([self timeframeForDate:dto.date]==4) {
            [hourItems addObject:dto];
        }
    }
    return hourItems;
}


- (NSInteger) timeframeForDate: (NSDate*) date {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:date];
    NSInteger hour = [components hour];
    if (0<=hour&&hour<6)   { return 4;}
    if (6<=hour&&hour<12)  { return 1;}
    if (12<=hour&&hour<16) { return 2;}
    if (16<=hour&&hour<20) { return 3;}
    if (20<=hour&&hour<24) { return 4;}
    return 0;
}



- (NSMutableArray*) allWeekItems {
    
    NSArray* healthItems = [HealthManager sharedInstance].retrieveAllItems;
    NSMutableArray* weekItems = [NSMutableArray new];
    for (HealthDTO* dto in healthItems) {
        if ((-dto.date.timeIntervalSinceNow)<60*60*24*7) {
            [weekItems addObject:dto];
        }
    }
    return weekItems;
}

- (NSMutableArray*) allTrimesterItems {
    
    NSArray* healthItems = [HealthManager sharedInstance].retrieveAllItems;
    NSMutableArray* fortItems = [NSMutableArray new];
    for (HealthDTO* dto in healthItems) {
        if ((-dto.date.timeIntervalSinceNow)<60*60*24*90) {
            [fortItems addObject:dto];
        }
    }
    return fortItems;
}

- (NSMutableArray*) allMonthItems {
    
    NSArray* healthItems = [HealthManager sharedInstance].retrieveAllItems;
    NSMutableArray* monthItems = [NSMutableArray new];
    for (HealthDTO* dto in healthItems) {
        if ((-dto.date.timeIntervalSinceNow)<60*60*24*30) {
            [monthItems addObject:dto];
        }
    }
    return monthItems;
}



@end
