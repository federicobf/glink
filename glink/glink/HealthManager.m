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
const float kWarnCH             = 200.0f;


const float kMinGlucemia        = 20.0f;
const float kHipoGlucemia       = 70.0f;
const float kHiperGlucemia      = 300.0f;
const float kMaxGlucemia        = 500.0f;

const float kMinGlucemiaOK      = 70.0f;
const float kMaxGlucemiaOK      = 140.0f;

const float kMinRelacion        = 1.0f;
const float kMaxRelacion        = 30.0f;

const float kMinTarget          = 70.0f;
const float kMaxTarget          = 200.0f;

const float kMinSensibilidad    = 10.0f;
const float kMaxSensibilidad    = 100.0f;

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

    CGFloat cantidadCH = self.cantidadch / self.relacionch;
    CGFloat cantidadGlucemia = (self.glucemia - self.target)/self.sensibilidad;
    if (cantidadGlucemia<0) {cantidadGlucemia = 0;}
    
    CGFloat bolo = (cantidadCH + cantidadGlucemia);
    

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

- (CGFloat) timeSinceLastEntry {

    if ([self retrieveAllItems].count==0) {
        return 100000000;
    }
    
    return -[self getLastEntryDate].timeIntervalSinceNow;

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
