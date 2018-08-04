//
//  ComidasViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/30/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "ComidasViewController.h"
#import "FoodTableViewCell.h"
#import "PureLayout.h"
#import "AppDelegate.h"
#import "SegmentedScrollView.h"
#import "FoodManager.h"
#import "GlucemiaViewController.h"
#import "CarbsViewController.h"
#import "glink-Swift.h"

@interface ComidasViewController () <ButtonPressDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray* sectionsArray;
@property (weak, nonatomic) IBOutlet SegmentedScrollView *segmentedScrollView;
@property (nonatomic, strong) NSString *currentKey;
@property (nonatomic, strong) NSString *lastUsedKey;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong) NSArray *tableViewCells;
@property (nonatomic, strong) NSString *preloadedString;
@property (nonatomic, strong) NSArray *fullOptions;
@property BOOL resignFlag;
@property BOOL layoutSet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentedConstraint;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UILabel *labelSearch;
@property (weak, nonatomic) IBOutlet UIButton *searchAgainButton;
@property (nonatomic, strong) NSString *totalText;
@property CGFloat totValue;

@end

@implementation ComidasViewController {
    CGFloat valorTotal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.segmentedScrollView.alpha = 0;
    [self.searchBar setBackgroundImage:[[UIImage alloc]init]];
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor blackColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.nextButton.layer.cornerRadius = 20;
    self.nextButton.layer.masksToBounds = YES;
    self.searchAgainButton.layer.cornerRadius = 20;
    self.searchAgainButton.layer.masksToBounds = YES;
    self.emptyView.hidden = YES;

    [self.segmentedScrollView addButtons:self.sectionsArray];
    self.segmentedScrollView.delegate = self;
    [self searchBar:self.searchBar textDidChange:self.preloadedString];
    if (self.noCategory) {
        [self hideSegmented];
        [self.searchBar becomeFirstResponder];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [self.segmentedScrollView setSelectedButton:self.currentKey animated:NO];
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.segmentedScrollView.alpha = 1;
    } completion:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.searchBar resignFirstResponder];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.layoutSet) {
        return;
    }
    self.layoutSet = YES;
    
    [self.searchBar layoutSubviews];
    
    float topPadding = 16.0;
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
- (IBAction)searchAgain:(id)sender {
    
    self.searchBar.text = @"";
    [self searchBar:self.searchBar textDidChange:@""];
    [self.searchBar becomeFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0) {
        self.tableViewCells = [self searchResultForString:searchText];
        [self hideSegmented];
    } else {
        if (self.resignFlag ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchBar resignFirstResponder];
            });
        }
        if (!self.noCategory) {
            [self showSegmented];
        }
        if (self.currentKey) {
            self.tableViewCells = [self dataSourceForKey:self.currentKey];
        } else {
            self.tableViewCells = [self storedItems];
        }
    }
    
    [self updateEmptyView];
    
    [self.tableView reloadData];
    self.resignFlag = YES;
}

- (NSArray *) storedItems
{
   NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"storedFoods"];
    if (array.count>0) {
        return array;
    }
    return [self fullOptions];
}

- (void) updateEmptyView
{
    self.emptyView.hidden = (self.tableViewCells.count != 0);
    if (!self.emptyView.hidden) {
        self.labelSearch.text = [NSString stringWithFormat:@"No se encontraron alimentos con la palabra “%@”", self.searchBar.text];
                                 }
}
- (IBAction)searchBack:(id)sender {
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    self.resignFlag = NO;
    return YES;
}

- (void) showSegmented
{
    [self.view layoutIfNeeded];
self.segmentedConstraint.constant = 60;
    [UIView animateWithDuration:.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) hideSegmented
{
    [self.view layoutIfNeeded];
    self.segmentedConstraint.constant = 0;
    [UIView animateWithDuration:.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void) actionPressed: (UIButton *) sender
{
    self.currentKey = sender.titleLabel.text;
    [self.segmentedScrollView setSelectedButton:self.currentKey animated:YES];
    self.tableViewCells = [self dataSourceForKey:self.currentKey];
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void) setUpWithCategories: (NSArray *) categories andCurrentKey:(NSString *) currentKey;
{
    self.sectionsArray = (NSMutableArray *) categories;
    self.currentKey = currentKey;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewCells.count;
}

- (NSArray*) dataSourceForKey: (NSString*) key {

    if (![self.lastUsedKey isEqualToString: key]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:key ofType:@"json"];
        NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        NSArray *result = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        self.lastUsedKey = key;
        self.dataSourceArray = result;
    }
    return self.dataSourceArray;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    return 0;
//
//}
//
//- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UIView* v = [[UIView alloc] init];
//    v.backgroundColor = [UIColor colorWithRed:255/255.f green:33/255.f blue:162/255.f alpha:.8f];
//                         
//    
//    UILabel* lbl = [[UILabel alloc] initForAutoLayout];
//    lbl.text = self.currentKey;
//    lbl.textColor = [UIColor whiteColor];
//    [v addSubview:lbl];
//    [lbl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    
//    return v;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell" forIndexPath:indexPath];
    
    NSArray* items = self.tableViewCells;
    FoodItem* foodItem = [FoodItem new];
    [foodItem configureWithDict:items [indexPath.row]];
    [cell setUpWithFoodItem: foodItem];
    
    if ([[FoodManager sharedInstance].selectionsDictionary objectForKey:foodItem.identificationKey]) {
    
        cell.amountTextfield.text = [NSString stringWithFormat:@"%lu", [[[FoodManager sharedInstance].selectionsDictionary objectForKey:foodItem.identificationKey] integerValue]];
        
    }
    else {
        cell.amountTextfield.text = @"0";
    }
    
    return cell;
}

- (void) scrollToCategory: (NSString*) category {

    NSInteger section = [self.sectionsArray indexOfObject:category];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (IBAction)porcionPlus:(id)sender {
    
    
    
    UIButton* button = (UIButton*) sender;
    
    FoodTableViewCell* cell;
    
    
    
    if ([button.superview isKindOfClass:[FoodTableViewCell class]]) {
        
        cell = (FoodTableViewCell*) button.superview;
        
    }
    
    
    
    if ([button.superview.superview isKindOfClass:[FoodTableViewCell class]]) {
        
        cell = (FoodTableViewCell*) button.superview.superview;
        
    }
    
    
    
    if ([button.superview.superview.superview isKindOfClass:[FoodTableViewCell class]]) {
        
        cell = (FoodTableViewCell*) button.superview.superview.superview;
        
    }
    
    
    
    
    
    NSLog(@"cell? %@ other? %@", button.superview, button.superview.superview.superview);
    
    
    
    
    
    [self performSelector:@selector(updateDictionaryWithCell:) withObject:cell afterDelay:.1f];
    
    
    
}



- (IBAction)porcionLess:(id)sender {
    
    
    
    UIButton* button = (UIButton*) sender;
    
    FoodTableViewCell* cell;
    
    
    
    if ([button.superview isKindOfClass:[FoodTableViewCell class]]) {
        
        cell = (FoodTableViewCell*) button.superview;
        
    }
    
    
    
    if ([button.superview.superview isKindOfClass:[FoodTableViewCell class]]) {
        
        cell = (FoodTableViewCell*) button.superview.superview;
        
    }
    
    
    
    NSLog(@"cell? %@ other? %@", button.superview, button.superview.superview);
    
    
    
    
    
    [self performSelector:@selector(updateDictionaryWithCell:) withObject:cell afterDelay:.1f];
    
    
    
}

- (void) updateDictionaryWithCell: (FoodTableViewCell*) cell {
    
    FoodItem* item = cell.foodItem;
    NSInteger value = [cell.amountTextfield.text integerValue];
    if (value == 0) {
        [[FoodManager sharedInstance].selectionsDictionary removeObjectForKey:item.identificationKey];
    } else {
        [[FoodManager sharedInstance].selectionsDictionary setObject:[NSNumber numberWithInteger:value] forKey:item.identificationKey];
    }
    
}

- (NSArray *) fullOptions
{
    if (!_fullOptions) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"FoodList" ofType:@"plist"];
        NSDictionary* root = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSArray *types = root [@"types"];
        NSMutableArray *categories = [NSMutableArray new];
        for (NSString *type in types) {
            NSArray *category = root [type];
            [categories addObjectsFromArray:category];
        }
        
        NSMutableArray *fullOptions = [NSMutableArray new];
        for (NSString *item in categories) {
            NSArray *items = [self dataSourceForKey:item];
            [fullOptions addObjectsFromArray:items];
        }
        
        //Sorting of the Array
        NSComparator comparator = ^NSComparisonResult(id aDictionary, id anotherDictionary) {
            NSString *oneString = [aDictionary objectForKey:@"Comida"];
            NSString *anotherString = [anotherDictionary objectForKey:@"Comida"];
            
            return [oneString localizedCaseInsensitiveCompare: anotherString];
        };
        NSArray *sortedArray = [fullOptions sortedArrayUsingComparator:comparator];
        _fullOptions = [NSArray arrayWithArray:sortedArray];
    }
    
    return _fullOptions;
}

- (NSMutableArray *) searchResultForString: (NSString*) string
{
    NSMutableArray* selectedItems = [NSMutableArray new];
    for (NSDictionary* item in [self fullOptions]) {
        NSString *comida = item[@"Comida"];
        if ([comida containsString:string]) {
                [selectedItems addObject:item];
        }
    }

    //Sorting of the Array
    NSComparator comparator = ^NSComparisonResult(id aDictionary, id anotherDictionary) {
        NSString *firstString = [aDictionary objectForKey:@"Comida"];
        NSString *secondString = [anotherDictionary objectForKey:@"Comida"];
        
        NSRange range1 = [firstString rangeOfString:string];
        NSRange range2 = [secondString rangeOfString:string];
        
        if (range1.location == range2.location) {
            return [firstString localizedCaseInsensitiveCompare: secondString];
        } else {
            return range1.location > range2.location;
        }

    };
    NSArray *sortedArray = [selectedItems sortedArrayUsingComparator:comparator];
    return sortedArray;
}

- (void) scrollToItem: (NSString*) item {

    NSMutableArray* allItems = [NSMutableArray new];
    NSString* sectionKey;
    NSInteger rowNumber = 0;
    for (NSString* key in self.sectionsArray) {
        NSArray* items = [self dataSourceForKey:key];
        NSMutableArray* titles = [NSMutableArray new];
        for (NSDictionary* dictItem in items) {
            [titles addObject:dictItem[@"Comida"]];
        }
        if ([titles containsObject:item]) {
            sectionKey = key;
        }
        
        for (int x = 0; x < titles.count; x++) {
            if ([titles[x] isEqualToString:item]) {
                rowNumber = x;
            }
        }
        
    }
    
    NSInteger section = [self.sectionsArray indexOfObject:sectionKey];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.view layoutIfNeeded];
    self.bottomConstraint.constant = 216-44;
    [UIView animateWithDuration:.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.view layoutIfNeeded];
    self.bottomConstraint.constant = 0;
    [UIView animateWithDuration:.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)calcularTotal:(id)sender {

    valorTotal = [self valorSumaTotal];
    self.totValue = valorTotal;
    if (valorTotal==-1) {
        return;
    }
    [self.tableView reloadData];
    [self performSegueWithIdentifier:@"carbsFlow" sender:nil];
    
}

- (CGFloat) valorSumaTotal {
    
    CGFloat totalValue = 0;
    
    NSString* descriptor = @"";
    
    NSMutableArray* allItems = [NSMutableArray new];
    for (NSDictionary* dictItem in [self fullOptions]) {
        
        FoodItem* foodItem = [FoodItem new];
        [foodItem configureWithDict:dictItem];
        [allItems addObject: foodItem];
    }
    
    NSMutableArray* allDictionaries = [NSMutableArray new];
    for (NSString* key in [[FoodManager sharedInstance].selectionsDictionary allKeys]) {
    
        FoodItem* myItem;
        for (FoodItem* item in allItems) {
            if ([item.identificationKey isEqualToString:key]) {
                [allDictionaries addObject:item.dictionary];
                myItem = item;
            }
        }
        
        CGFloat value = myItem.glucidos;
        NSInteger amount = [[FoodManager sharedInstance].selectionsDictionary [key] integerValue];
        
        NSString *shortString = ([myItem.comida length]>18 ? [NSString stringWithFormat:@"%@...", [myItem.comida substringToIndex:15]] : myItem.comida);
        
        descriptor = [NSString stringWithFormat:@"%@\n%@: %lu x %.0fg = %.0fg",descriptor, shortString, amount,myItem. glucidos, myItem.glucidos * amount];
        NSLog(@"Item %@: value %f x amount %lu", myItem.comida, myItem.glucidos, amount);
        
        totalValue = totalValue + (value*amount);
        
    }
    
    if ([FoodManager sharedInstance].selectionsDictionary.allKeys.count == 0) {
        ZAlertView *alert = [[ZAlertView alloc] initWithTitle:@"Error" message:@"Por favor agregue al menos una porción en alguno de los items disponibles para poder continuar." closeButtonText:@"De acuerdo" closeButtonHandler:^(ZAlertView * _Nonnull alertview) {
            [alertview dismissAlertView];
        }];
        [alert show];
        return -1;
    }
    
    [self updateStoredItemsWithArray:allDictionaries];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchBar resignFirstResponder];
    });
    
    self.totalText = [NSString stringWithFormat:@"Se ha calculado un valor total de %.0fg para los siguientes items: %@", totalValue, descriptor];
    
    return totalValue;
    
}

- (void) updateStoredItemsWithArray: (NSArray *) array
{
    NSMutableArray *mutArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"storedFoods"] mutableCopy];
    [mutArray addObjectsFromArray:array];
    
    
    //Sorting of the Array
    NSComparator comparator = ^NSComparisonResult(id aDictionary, id anotherDictionary) {
        return [[aDictionary objectForKey:@"Comida"] localizedCaseInsensitiveCompare:[anotherDictionary objectForKey:@"Comida"]];
    };
    NSArray *sortedArray = [mutArray sortedArrayUsingComparator:comparator];
    
    NSMutableArray *newArray = [NSMutableArray new];
    for (NSDictionary *dic in sortedArray) {
        if (![newArray containsObject:dic]) {
            [newArray addObject:dic];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject: newArray.copy forKey:@"storedFoods"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"carbsFlow"]) {
        UIViewController *nextVC = [segue destinationViewController];
        if ([nextVC isKindOfClass:[GlucemiaViewController class]]) {
            CarbsViewController *comidasVC = (CarbsViewController *) nextVC;
            comidasVC.initialValue = self.totValue;
            comidasVC.initialText = self.totalText;
        }
    }
}
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
