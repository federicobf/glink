//
//  FoodManager.m
//  glink
//
//  Created by Federico Bustos Fierro on 4/22/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "FoodManager.h"

@implementation FoodManager

+ (instancetype)sharedInstance
{
    static FoodManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FoodManager alloc] init];
        sharedInstance.selectionsDictionary = [NSMutableDictionary new];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

@end
