//
//  SelectGroupViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 4/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "SelectGroupViewController.h"
#import "FoodCollectionViewCell.h"
#import "PureLayout.h"
#import "SelectCategoryViewController.h"
#import "ComidasViewController.h"

@interface SelectGroupViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property CGFloat delayMultiplier;
@property BOOL layoutSet;
@end

@implementation SelectGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.searchbar.barTintColor = [UIColor whiteColor];
    [self.searchbar setBackgroundImage:[[UIImage alloc]init]];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.delayMultiplier = .3f;
    [self performSelector:@selector(killMultiplier) withObject:nil afterDelay:.2f];
}

- (void) killMultiplier
{
    self.delayMultiplier = 0;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.searchbar layoutSubviews];
    
    if (self.layoutSet) {
        return;
    }
    self.layoutSet = YES;
    
    float topPadding = 16.0;
    for(UIView *view in self.searchbar.subviews)
    {
        for(UITextField *textfield in view.subviews)
        {
            if ([textfield isKindOfClass:[UITextField class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [textfield autoSetDimension:ALDimensionHeight toSize:40];
                    [textfield autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:textfield.superview];
                    [textfield autoCenterInSuperview];
                });

            }
        }
    }
}


- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat halfWidth = [UIScreen mainScreen].bounds.size.width/2.f-10;
    return CGSizeMake(halfWidth, 149.f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FoodCategoryCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[self imageForPosition:indexPath.row]];
    cell.text.text = [self titleForPosition:indexPath.row];
    cell.alpha = 0.f;
        [UIView animateWithDuration:.8f delay:indexPath.row * self.delayMultiplier options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.alpha = 1.f;
        } completion:nil];
    return cell;
}

- (NSString *) titleForPosition: (NSInteger) position
{
    switch (position) {
        case 0:
            return @"Carbohidratos";
            break;
        case 1:
            return @"Dulces";
            break;
        case 2:
            return @"Lacteos";
            break;
        case 3:
            return @"Bebidas";
            break;
        case 4:
            return @"Vegetales";
            break;
        case 5:
            return @"Lípidos";
            break;
        case 6:
            return @"Añadir alimento";
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSString *) imageForPosition: (NSInteger) position
{
    switch (position) {
        case 0:
            return @"Carbohidratos";
            break;
        case 1:
            return @"Dulces";
            break;
        case 2:
            return @"Lacteos";
            break;
        case 3:
            return @"Bebidas";
            break;
        case 4:
            return @"Vegetales";
            break;
        case 5:
            return @"Lipidos";
            break;
        case 6:
            return @"Anadir alimento";
            break;
            
        default:
            return nil;
            break;
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self collectionView:self.collectionView numberOfItemsInSection:0]-1) {
        [self performSegueWithIdentifier:@"suggestFood" sender:indexPath];
        return;
    }
    [self performSegueWithIdentifier:@"categorySelection" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *ip = sender;
    UIViewController *nextVC = [segue destinationViewController];
    if ([nextVC isKindOfClass:[SelectCategoryViewController class]]) {
        SelectCategoryViewController *categoryVC = (SelectCategoryViewController *) nextVC;
        categoryVC.key = [self imageForPosition:ip.row];
    }
    
    if ([nextVC isKindOfClass:[ComidasViewController class]]) {
        ComidasViewController *comidasVC = (ComidasViewController *) nextVC;
        comidasVC.noCategory = YES;
    }
}

@end
