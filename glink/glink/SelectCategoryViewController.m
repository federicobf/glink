//
//  SelectCategoryViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 4/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "SelectCategoryViewController.h"
#import "SegmentedScrollView.h"

@interface SelectCategoryViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet SegmentedScrollView *segmentedScrollView;
@property (strong, nonatomic) NSArray *listArray;

@end

@implementation SelectCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.barTintColor = [UIColor whiteColor];
    [self.searchBar setBackgroundImage:[[UIImage alloc]init]];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"FoodList" ofType:@"plist"];
    NSDictionary* root = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    self.categories = root [@"types"];
    
    [self.segmentedScrollView addButtons:self.categories];
    self.segmentedScrollView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.listArray = [[self dataSourceForKey:self.key] copy];
    [self.tableView reloadData];
}


- (void) actionPressed: (UIButton *) sender
{
    self.listArray = [[self dataSourceForKey:sender.titleLabel.text] copy];
    [self.tableView reloadData];
}

- (NSArray*) dataSourceForKey: (NSString*) key {
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"FoodList" ofType:@"plist"];
    NSDictionary* root = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return [root [key] copy];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.searchBar layoutSubviews];
    
    float topPadding = 16.0;
    for(UIView *view in self.searchBar.subviews)
    {
        for(UITextField *textfield in view.subviews)
        {
            if ([textfield isKindOfClass:[UITextField class]]) {
                textfield.frame = CGRectMake(textfield.frame.origin.x, topPadding, textfield.frame.size.width, (self.searchBar.frame.size.height - (topPadding * 2)));
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
    return cell;
}



- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
