//
//  FoodManager.h
//  glink
//
//  Created by Federico Bustos Fierro on 4/22/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodManager : NSObject
@property (nonatomic, strong) NSMutableDictionary *selectionsDictionary;
+ (instancetype)sharedInstance;
@end
