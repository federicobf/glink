//
//  SegmentedScrollView.h
//  glink
//
//  Created by Federico Bustos Fierro on 4/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonPressDelegate <NSObject>

- (void) actionPressed: (UIButton *) sender;

@end

@interface SegmentedScrollView : UIScrollView
@property (weak) id <ButtonPressDelegate> delegate;
- (void) addButtons: (NSArray *) buttons;
- (void) setSelectedButton: (NSString *) buttonText animated:(BOOL) animated;
@end
