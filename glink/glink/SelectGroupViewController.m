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

@interface SelectGroupViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@end

@implementation SelectGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.searchbar.barTintColor = [UIColor whiteColor];
    [self.searchbar setBackgroundImage:[[UIImage alloc]init]];
    

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.searchbar layoutSubviews];
    
    float topPadding = 16.0;
    for(UIView *view in self.searchbar.subviews)
    {
        for(UITextField *textfield in view.subviews)
        {
            if ([textfield isKindOfClass:[UITextField class]]) {
                textfield.frame = CGRectMake(textfield.frame.origin.x, topPadding, textfield.frame.size.width, (self.searchbar.frame.size.height - (topPadding * 2)));
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
    CGFloat halfWidth = [UIScreen mainScreen].bounds.size.width/2.f;
    return CGSizeMake(halfWidth, 149.f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FoodCategoryCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[self titleForPosition:indexPath.row]];
    cell.text.text = [self titleForPosition:indexPath.row];
    cell.alpha = 0.f;
        [UIView animateWithDuration:.8f delay:indexPath.row * .3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.alpha = 1.f;
        } completion:nil];
    return cell;
}

- (NSString *) titleForPosition: (NSInteger) position
{
    switch (position) {
        case 0:
            return @"Almidones";
            break;
        case 1:
            return @"Lacteos";
            break;
        case 2:
            return @"Sustancias grasas";
            break;
        case 3:
            return @"Vegetales";
            break;
        case 4:
            return @"Accesorios";
            break;
            
        default:
            return nil;
            break;
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"categorySelection" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *ip = sender;
    SelectCategoryViewController *nextVC = [segue destinationViewController];
    nextVC.key = [self titleForPosition:ip.row];
    // Pass the selected object to the new view controller.
}

@end
