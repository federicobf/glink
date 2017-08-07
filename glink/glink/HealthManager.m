//
//  HealthManager.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/12/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "HealthManager.h"


const float kMinCH              = 0.0f;
const float kMaxCH              = 300.0f;
const float kWarnCH             = 150.0f;


const float kMinGlucemia        = 20.0f;
const float kHipoGlucemia       = 70.0f;
const float kHiperGlucemia      = 200.0f;
const float kMaxGlucemia        = 500.0f;

const float kMinGlucemiaOK      = 70.0f;
const float kMaxGlucemiaOK      = 140.0f;

const float kMinRelacion        = 1.0f;
const float kMaxRelacion        = 40.0f;

const float kMinTarget          = 70.0f;
const float kMaxTarget          = 300.0f;

const float kMinSensibilidad    = 5.0f;
const float kMaxSensibilidad    = 100.0f;

const float kMinInsulina   = 0.0f;
const float kMaxInsulina    = 20.0f;

@implementation HealthManager

+ (instancetype)sharedInstance
{
    static HealthManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HealthManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (float) calculoFinalBolo {

    float cantidadCH = self.cantidadch / self.relacionch;
    float cantidadGlucemia = (self.glucemia - self.target)/self.sensibilidad;
    if (cantidadGlucemia<0) {cantidadGlucemia = 0;}
    
    float bolo = (cantidadCH + cantidadGlucemia) * self.reductionFactor;

    return bolo;

}


- (void) storeNewItem: (HealthDTO*) dto {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"HealthItems"]) {
        NSMutableArray* items = [NSMutableArray new];
        [[NSUserDefaults standardUserDefaults] setObject:items forKey:@"HealthItems"];
    }
    
    NSMutableArray* currentItems = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"HealthItems"]];
    
    
    
    [currentItems addObject:[NSKeyedArchiver archivedDataWithRootObject:dto]];
    [[NSUserDefaults standardUserDefaults] setObject:currentItems forKey:@"HealthItems"];
    
    
}

- (NSMutableArray*) retrieveAllItems {

    NSMutableArray* currentItems = [[NSUserDefaults standardUserDefaults] objectForKey:@"HealthItems"];
    
    NSMutableArray* returnItems = [NSMutableArray new];
    
    for (NSData* itemData in currentItems) {
        HealthDTO* dto = [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
        [returnItems addObject:dto];
    }
    
    return returnItems;
    
}


- (BOOL) deleteObject: (HealthDTO*) targetDto {
    
    NSMutableArray* currentItems = [[NSUserDefaults standardUserDefaults] objectForKey:@"HealthItems"];
    NSMutableArray* mutableItems = [[NSMutableArray alloc]initWithArray:currentItems];
    
    NSData* foundObject;
    for (NSData* itemData in currentItems) {
        HealthDTO* dto = [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
        if (dto.glucemia == targetDto.glucemia && dto.carbohidratos == targetDto.carbohidratos && dto.insulina == targetDto.insulina && [dto.date isEqualToDate:targetDto.date]) {
            foundObject = itemData;
        }
    }
    
    if (foundObject && [mutableItems containsObject:foundObject]) {
        [mutableItems removeObject:foundObject];
        [[NSUserDefaults standardUserDefaults] setObject:mutableItems.copy forKey:@"HealthItems"];
        return YES;
    }
    
    return NO;
}

- (CGFloat) timeSinceLastEntry {

    if ([self retrieveAllItems].count==0) {
        return 100000000;
    }
    
    float interval = -[self getLastEntryDate].timeIntervalSinceNow;
    
    if (interval < 0) {
        interval = 0;
    }
    
    return interval;

}

- (NSDate*) getLastEntryDate {
    
    NSArray* items = [[self retrieveAllItems] sortedArrayUsingComparator:^NSComparisonResult(HealthDTO* a, HealthDTO* b) {
        
        CGFloat timeA = a.date.timeIntervalSince1970;
        CGFloat timeB = b.date.timeIntervalSince1970;
        return timeA>timeB;
    }];

    HealthDTO* dto = items.lastObject;
    
    return dto.date;
    
}

- (NSMutableArray*) retrieveAllDayItems {
    
    NSMutableArray* days = [NSMutableArray new];
    
    for (HealthDTO* dto in [self retrieveAllItems]) {
        
        
        HealthDayDTO* concurrentDay;
        
        for (HealthDayDTO* day in days) {
            if (day.date.timeIntervalSince1970 == [dto getSimpleDate].timeIntervalSince1970) {
                concurrentDay = day;
            }
        }
        
        if (concurrentDay) {
        
            [concurrentDay.healthItems addObject:dto];
        
        }
        else {
        
            HealthDayDTO* newDay = [HealthDayDTO new];
            [newDay.healthItems addObject:dto];
            newDay.date = [dto getSimpleDate];
            [days addObject:newDay];
        }
        

    }
    
    return days;
    

}

@end
