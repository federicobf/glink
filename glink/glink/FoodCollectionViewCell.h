//
//  FoodCollectionViewCell.h
//  glink
//
//  Created by Federico Bustos Fierro on 4/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (nonatomic) BOOL animationOngoing;
@end
