//
//  FirstTimeUseViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 4/29/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "FirstTimeUseViewController.h"

@interface FirstTimeUseViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *comenzar;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *saltear;
@property (weak, nonatomic) IBOutlet UIImageView *ftu1;
@property (weak, nonatomic) IBOutlet UIImageView *ftu2;
@property (weak, nonatomic) IBOutlet UIImageView *ftu3;
@property (weak, nonatomic) IBOutlet UIImageView *ftu4;
@property (weak, nonatomic) IBOutlet UIImageView *bluearrow;

@end

@implementation FirstTimeUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.comenzar.layer.cornerRadius = 23;
    self.comenzar.layer.masksToBounds = YES;
    self.comenzar.alpha = 0;
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    [self updateCurrentViewWithPage:0];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:.3f animations:^{
        self.titleLabel.alpha = 0;
        self.descriptionLabel.alpha = 0;
    }];
}

- (NSArray *) ftuImages
{
    return @[self.ftu1, self.ftu2, self.ftu3, self.ftu4];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int randNumber = arc4random() % 5;
    if (randNumber == 0) {
        return;
    }
    for (UIImageView *imgView in [self ftuImages]) {
        float center = imgView.center.x;
        float halfScreen =  scrollView.bounds.size.width/2;
        float screen2 = scrollView.bounds.size.width * 1.5f;
        float posx = scrollView.contentOffset.x + halfScreen;
        float desviation =  posx - center;
        float normalized = (desviation > 0)? desviation : -desviation;
        float antivalue = screen2 - normalized;
        
        if (imgView == self.ftu1) {
            NSLog(@"c %.1f", antivalue);
        }
        float cropped = antivalue > 0? antivalue : 0;
        float opacity = antivalue / screen2;
        imgView.alpha = opacity;
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = [self paginaActual];
    [self updateCurrentViewWithPage:page];
}

- (IBAction)flechaPress:(id)sender
{
    NSInteger page = [self paginaActual];
    
    if (page == 3) {
        [self performSegueWithIdentifier:@"continue" sender:nil];
        return;
    }
    
    page++;
    [self goToPage:page];
    [UIView animateWithDuration:.3f animations:^{
        self.titleLabel.alpha = 0;
        self.descriptionLabel.alpha = 0;
    }completion:^(BOOL finished) {
        [self updateCurrentViewWithPage:page];
    }];
}

- (void) goToPage: (NSInteger) page
{
    float distanciaX = page * self.scrollView.frame.size.width;
    [self.scrollView scrollRectToVisible:CGRectMake(distanciaX, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
}

- (NSInteger) paginaActual
{
    return self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
}

- (IBAction)changePage:(id)sender {
    UIPageControl *pager=sender;
    int page = pager.currentPage;
    [self goToPage:page];
    [self updateCurrentViewWithPage:page];
}

- (void) updateCurrentViewWithPage: (NSInteger) page
{
    NSString *titleString;
    NSString *descriptionString;
    
    switch (page) {
        case 0:
            titleString = @"Calcula tu medida de bolo";
            descriptionString = @"Calcula la cantidad de bolo que necesites suministrarte para tu comida diaria.";
            break;
        case 1:
            titleString = @"Busca entre un completo listado de alimentos";
            descriptionString = @"Un listado de alimentos con información nutricional para saber qué vas a ingerir.";
            break;
        case 2:
            titleString = @"Mantén un seguimiento de tu salud";
            descriptionString = @"Los gráficos y las estadísticas te permiten a tí y tu médico personal hacer un seguimiento de tu salud.";
            break;
        case 3:
            titleString = @"Envía a tu médico un informe completo";
            descriptionString = @"Rápidamente y en formato PDF puedes enviar a tu médico personal las últimas mediciones y estadísticas de tu diabetes.";
            break;
        default:
            break;
    }
    [self updateWithTitle:titleString description:descriptionString];
    
    [UIView animateWithDuration:.3f animations:^{
        self.titleLabel.alpha = 1;
        self.descriptionLabel.alpha = 1;
    }];
    
    self.pageControl.currentPage = page;
    
    
    if (page == 3) {
        [UIView animateWithDuration:.3f animations:^{
            self.comenzar.alpha = 1;
            self.saltear.alpha = 0;
            self.bluearrow.alpha = 0;
        }];
    } else {
        [UIView animateWithDuration:.3f animations:^{
            self.comenzar.alpha = 0;
            self.saltear.alpha = 1;
            self.bluearrow.alpha = 1;
        }];
    }
}

- (void) updateWithTitle: (NSString *) title description: (NSString *) description
{
    self.titleLabel.text = title;
    self.descriptionLabel.text = description;
}


@end
