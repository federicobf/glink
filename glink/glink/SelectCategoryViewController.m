//
//  SelectCategoryViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 4/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "SelectCategoryViewController.h"
#import "SegmentedScrollView.h"
#import "ComidasViewController.h"
#import "PureLayout.h"

@interface SelectCategoryViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet SegmentedScrollView *segmentedScrollView;
@property (strong, nonatomic) NSArray *listArray;
@property CGFloat delayMuliplier;
@property BOOL layoutSet;
@property BOOL voidCategories;

@end

@implementation SelectCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delayMuliplier = 1;
    self.searchBar.barTintColor = [UIColor whiteColor];
    [self.searchBar setBackgroundImage:[[UIImage alloc]init]];
    self.segmentedScrollView.alpha = 0;
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"FoodList" ofType:@"plist"];
    NSDictionary* root = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    self.categories = root [@"types"];
    
    [self.segmentedScrollView addButtons:self.categories];
    self.segmentedScrollView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.listArray = [[self dataSourceForKey:self.key] copy];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void) viewDidAppear:(BOOL)animated
{
    self.delayMuliplier = 0;
    [self.segmentedScrollView setSelectedButton:self.key animated:NO];
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.segmentedScrollView.alpha = 1;
    } completion:nil];
    self.voidCategories = YES;
}

- (void) actionPressed: (UIButton *) sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.listArray = [[self dataSourceForKey:sender.titleLabel.text] copy];
        [self.segmentedScrollView setSelectedButton:sender.titleLabel.text animated:YES];
        self.delayMuliplier = 1;
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [self performSelector:@selector(cancelOutMultiplier) withObject:nil afterDelay:.05f];
    });
}

- (void) cancelOutMultiplier
{
    self.delayMuliplier = 0;
}

- (NSArray*) dataSourceForKey: (NSString*) key {
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"FoodList" ofType:@"plist"];
    NSDictionary* root = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return [root [key] copy];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.layoutSet) {
        return;
    }
    self.layoutSet = YES;
    
    [self.searchBar layoutSubviews];
    
    for(UIView *view in self.searchBar.subviews)
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simpleCell" forIndexPath:indexPath];
    cell.textLabel.text = self.listArray [indexPath.row];
    cell.alpha = 0.f;
    
    float delay = indexPath.row * self.delayMuliplier*.12f;
    [UIView animateWithDuration:.5f delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.alpha = 1.f;
    } completion:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.voidCategories = NO;
    [self performSegueWithIdentifier:@"foodlist" sender:self.listArray [indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *nextVC = [segue destinationViewController];
    if ([nextVC isKindOfClass:[ComidasViewController class]]) {
        ComidasViewController *comidasVC = (ComidasViewController *) nextVC;
        if (self.voidCategories) {
            comidasVC.noCategory = YES;
        } else {
            [comidasVC setUpWithCategories:self.listArray andCurrentKey:(NSString *)sender];
        }
    }
}



- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
