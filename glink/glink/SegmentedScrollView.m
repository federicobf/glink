//
//  SegmentedScrollView.m
//  glink
//
//  Created by Federico Bustos Fierro on 4/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "SegmentedScrollView.h"
#import "PureLayout.h"
@interface SegmentedScrollView ()
@property UIView *innerContentView;
@property NSMutableArray *buttonArray;
@end

@implementation SegmentedScrollView

- (void) addButtons: (NSArray *) buttons
{
    self.canCancelContentTouches = YES;
    self.buttonArray = [NSMutableArray new];
    self.showsHorizontalScrollIndicator = NO;
    self.innerContentView = [[UIView alloc] initForAutoLayout];
    [self addSubview:self.innerContentView];
    [self.innerContentView autoPinEdgesToSuperviewEdges];
    self.innerContentView.backgroundColor = [UIColor whiteColor];
    [self.innerContentView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self];
    UIButton *lastButton = nil;
    int position = 0;
    for (NSString *string in buttons) {
        
        
        UIButton *button = [[UIButton alloc] initForAutoLayout];
        button.tag = position;
        [self.innerContentView addSubview:button];
        button.backgroundColor = [UIColor colorWithRed:243/255.f green:244/255.f blue:245/255.f alpha:1];
        [button autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [button autoSetDimension:ALDimensionHeight toSize:30];
        
        if (self.hardWidth) {
            [button autoSetDimension:ALDimensionWidth toSize:self.hardWidth];
        }
        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self.delegate action:@selector(actionPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:button];
        
        UIView *bgView = [[UIView alloc] initForAutoLayout];
        [self.innerContentView addSubview:bgView];
        bgView.backgroundColor = [UIColor colorWithRed:243/255.f green:244/255.f blue:245/255.f alpha:1];
        [bgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:button];
        [bgView autoAlignAxis:ALAxisVertical toSameAxisOfView:button];
        [bgView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:button];
        [bgView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:button withOffset:10];
        bgView.layer.cornerRadius = 8;
        [self.innerContentView addSubview:bgView];
        [self.innerContentView sendSubviewToBack:bgView];
        
        
        if (position == 0) {
            [button autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.innerContentView withOffset:20];
        } else if (position == buttons.count - 1) {
            [button autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lastButton withOffset:20];
            [button autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.innerContentView withOffset:-20];
        } else {
            [button autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lastButton withOffset:20];
        }
        lastButton = button;
        
        position++;
    }
}

- (void) setSelectedButton: (NSString *) buttonText animated:(BOOL) animated
{
    for (UIButton *button in self.buttonArray) {
        if ([button.titleLabel.text isEqualToString:buttonText]) {
            button.backgroundColor = [UIColor colorWithRed:232/255.f green:244/255.f blue:253/255.f alpha:1];
            [button setTitleColor:[UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1] forState:UIControlStateNormal];
            CGRect visibleFrame = CGRectMake(button.frame.origin.x-20, button.frame.origin.y, button.frame.size.width+40, button.frame.size.height);
            [self scrollRectToVisible:visibleFrame animated:animated];
        } else {
            button.backgroundColor = [UIColor colorWithRed:243/255.f green:244/255.f blue:245/255.f alpha:1];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
}

@end
