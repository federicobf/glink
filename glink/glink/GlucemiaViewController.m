//
//  GlucemiaViewController.m
//  glink
//
//  Created by Federicuelo on 15/4/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "GlucemiaViewController.h"
#import "StrippedView.h"



@interface GlucemiaViewController ()
@property (weak, nonatomic) IBOutlet StrippedView *strippedView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

@implementation GlucemiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextButton.layer.cornerRadius = 20;
    self.nextButton.layer.masksToBounds = YES;
    [self.strippedView drawLines];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float distanciaX = scrollView.contentOffset.x;
    float glucemia = distanciaX / 5.f;
    
    if (glucemia < 0) {
        glucemia = 0;
    }
    
    if (glucemia > 300) {
        glucemia = 300;
    }
    
    self.amountLabel.text = [NSString stringWithFormat:@"%.2f", glucemia];
}

@end
