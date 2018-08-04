//
//  StatisticsViewController.m
//  glink
//
//  Created by Federico Bustos Fierro on 6/18/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import "StatisticsViewController.h"
#import "SegmentedScrollView.h"
#import "HealthManager.h"
#import "StatisticsTableViewCell.h"
#import "PureLayout.h"
#import "PresentiationViewController.h"

@interface StatisticsViewController () <ButtonPressDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *dWeek;
@property (weak, nonatomic) IBOutlet UILabel *dFortnight;
@property (weak, nonatomic) IBOutlet UILabel *dMonth;
@property (weak, nonatomic) IBOutlet UILabel *dPreviousMonth;
@property (weak, nonatomic) IBOutlet UILabel *aWeek;
@property (weak, nonatomic) IBOutlet UILabel *aFortnight;
@property (weak, nonatomic) IBOutlet UILabel *aMonth;
@property (weak, nonatomic) IBOutlet UILabel *aPreviousMonth;
@property (weak, nonatomic) IBOutlet UILabel *mWeek;
@property (weak, nonatomic) IBOutlet UILabel *mFortnight;
@property (weak, nonatomic) IBOutlet UILabel *mMonth;
@property (weak, nonatomic) IBOutlet UILabel *mPreviousMonth;
@property (weak, nonatomic) IBOutlet UILabel *cWeek;
@property (weak, nonatomic) IBOutlet UILabel *cFortnight;
@property (weak, nonatomic) IBOutlet UILabel *cMonth;
@property (weak, nonatomic) IBOutlet UILabel *cPreviousMonth;
@property (nonatomic, strong) NSArray* healthDays;
@property (weak, nonatomic) IBOutlet SegmentedScrollView *segmentedScrollView;
@property (weak, nonatomic) IBOutlet UIView *graphicView;
@property (strong, nonatomic) StatisticsTableViewCell *innerCell;
@property (strong, nonatomic) HealthDayDTO *lastHealthDay;
@property int touchCounter;
@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpScrollView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshInformation)
                                                 name:@"refreshStatistics"
                                               object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshInformation];
}

- (void) refreshInformation {
    [self loadGlucemiaData];
    
    self.healthDays =  [[HealthManager sharedInstance].retrieveAllDayItems sortedArrayUsingComparator:^NSComparisonResult(HealthDayDTO* a, HealthDayDTO* b) {
        
        CGFloat timeA = a.date.timeIntervalSince1970;
        CGFloat timeB = b.date.timeIntervalSince1970;
        return timeA>timeB;
    }];
    
    NSMutableArray *segmentedDays = [NSMutableArray new];
    self.lastHealthDay = nil;
    for (HealthDayDTO *day in self.healthDays) {
        [segmentedDays addObject:[day dateKey]];
        self.lastHealthDay = day;
    }
    
    [self.segmentedScrollView addButtons: segmentedDays];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.segmentedScrollView setSelectedButton:[self.lastHealthDay dateKey] animated:YES];
        [self.segmentedScrollView setSelectedButton:[self.lastHealthDay dateKey] animated:NO];
    });

    self.segmentedScrollView.delegate = self;
    
    [self setUpGraphicViewWithHealthDay:self.lastHealthDay];
}

- (void) setUpGraphicViewWithHealthDay: (HealthDayDTO *) healthDay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.innerCell removeFromSuperview];
        
        self.graphicView.backgroundColor = [UIColor redColor];
        self.innerCell = [[StatisticsTableViewCell alloc] init];
        [self.graphicView addSubview:self.innerCell];
        [self.innerCell autoPinEdgesToSuperviewEdges];
        self.innerCell.type = self.segmentedControl.selectedSegmentIndex;
        [self.innerCell configureWithHealthDay:healthDay];
        self.graphicView.alpha = 0;
        [UIView animateWithDuration:.3f animations:^{
            self.graphicView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    });

}
- (IBAction)newItemAction:(id)sender {
    
    self.touchCounter++;
    if (!(self.touchCounter & 3)) {
        [self performSegueWithIdentifier:@"newItem" sender:nil];
    }
}

- (void) actionPressed: (UIButton *) sender
{
    if (self.graphicView.alpha != 1) {
        return;
    }
    
    [self.segmentedScrollView setSelectedButton:sender.titleLabel.text animated:YES];
    for (HealthDayDTO *day in self.healthDays) {
        if ([[day dateKey] isEqualToString:sender.titleLabel.text]) {
            self.lastHealthDay = day;
            [self setUpGraphicViewWithHealthDay:self.lastHealthDay];
            NSLog(@"encontre health day para el %@", [day dateKey]);
        }
    }
}

- (NSArray *) labelsArray
{
    return @[self.dWeek, self.dFortnight, self.dMonth, self.dPreviousMonth, self.aWeek, self.aFortnight, self.aMonth, self.aPreviousMonth, self.mWeek, self.mFortnight, self.mMonth, self.mPreviousMonth, self.cWeek, self.cFortnight, self.cMonth, self.cPreviousMonth];
}

- (IBAction)changeFilter:(id)sender {
    [self setUpGraphicViewWithHealthDay:self.lastHealthDay];
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            [self loadGlucemiaData];
            break;
        case 1:
            [self loadCarbohidratosData];
            break;
        case 2:
            [self loadInsulinaData];
            break;
            
        default:
            break;
    }
    
}

- (void) loadGlucemiaData {
    
    self.dWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForDesayuno:[self allWeekItems]]]];
    self.dFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForDesayuno:[self allFortnightItems]]]];
    self.dMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForDesayuno:[self allMonthItems]]]];
    self.dPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForDesayuno:[self allPreviousMonthItems]]]];
    
    self.aWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForAlmuerzo:[self allWeekItems]]]];
    self.aFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForAlmuerzo:[self allFortnightItems]]]];
    self.aMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForAlmuerzo:[self allMonthItems]]]];
    self.aPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForAlmuerzo:[self allPreviousMonthItems]]]];
    
    self.mWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForMerienda:[self allWeekItems]]]];
    self.mFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForMerienda:[self allFortnightItems]]]];
    self.mMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForMerienda:[self allMonthItems]]]];
    self.mPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForMerienda:[self allPreviousMonthItems]]]];
    
    self.cWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForCena:[self allWeekItems]]]];
    self.cFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForCena:[self allFortnightItems]]]];
    self.cMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForCena:[self allMonthItems]]]];
    self.cPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpGlucemia:[self filterItemsForCena:[self allPreviousMonthItems]]]];
    
    [self checkFields];
}

- (void) loadCarbohidratosData {
    
    self.dWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForDesayuno:[self allWeekItems]]]];
    self.dFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForDesayuno:[self allFortnightItems]]]];
    self.dMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForDesayuno:[self allMonthItems]]]];
    self.dPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForDesayuno:[self allPreviousMonthItems]]]];
    
    self.aWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForAlmuerzo:[self allWeekItems]]]];
    self.aFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForAlmuerzo:[self allFortnightItems]]]];
    self.aMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForAlmuerzo:[self allMonthItems]]]];
    self.aPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForAlmuerzo:[self allPreviousMonthItems]]]];
    
    self.mWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForMerienda:[self allWeekItems]]]];
    self.mFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForMerienda:[self allFortnightItems]]]];
    self.mMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForMerienda:[self allMonthItems]]]];
    self.mPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForMerienda:[self allPreviousMonthItems]]]];
    
    self.cWeek.text             = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForCena:[self allWeekItems]]]];
    self.cFortnight.text        = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForCena:[self allFortnightItems]]]];
    self.cMonth.text            = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForCena:[self allMonthItems]]]];
    self.cPreviousMonth.text    = [NSString stringWithFormat:@"%.f", [self sumUpCarbohidratos:[self filterItemsForCena:[self allPreviousMonthItems]]]];
    
    [self checkFields];
}

- (void) loadInsulinaData {
    
    self.dWeek.text             = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForDesayuno:[self allWeekItems]]]];
    self.dFortnight.text        = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForDesayuno:[self allFortnightItems]]]];
    self.dMonth.text            = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForDesayuno:[self allMonthItems]]]];
    self.dPreviousMonth.text    = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForDesayuno:[self allPreviousMonthItems]]]];
    
    self.aWeek.text             = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForAlmuerzo:[self allWeekItems]]]];
    self.aFortnight.text        = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForAlmuerzo:[self allFortnightItems]]]];
    self.aMonth.text            = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForAlmuerzo:[self allMonthItems]]]];
    self.aPreviousMonth.text    = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForAlmuerzo:[self allPreviousMonthItems]]]];
    
    self.mWeek.text             = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForMerienda:[self allWeekItems]]]];
    self.mFortnight.text        = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForMerienda:[self allFortnightItems]]]];
    self.mMonth.text            = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForMerienda:[self allMonthItems]]]];
    self.mPreviousMonth.text    = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForMerienda:[self allPreviousMonthItems]]]];
    
    self.cWeek.text             = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForCena:[self allWeekItems]]]];
    self.cFortnight.text        = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForCena:[self allFortnightItems]]]];
    self.cMonth.text            = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForCena:[self allMonthItems]]]];
    self.cPreviousMonth.text    = [NSString stringWithFormat:@"%.2f", [self sumUpInsulina:[self filterItemsForCena:[self allPreviousMonthItems]]]];
    
    [self checkFields];
    
}

- (void) checkFields
{
    for (UILabel* lbl in [self labelsArray]) {
            if ([lbl.text isEqualToString:@"nan"]) {
                lbl.text = @"-";
            }
    }
    
}




- (CGFloat) sumUpInsulina: (NSMutableArray*) items {
    CGFloat sumup = 0;
    NSInteger count = 0;
    for (HealthDTO* dto in items) {
        if (dto.insulina != 0) {count++;}
        sumup= sumup + dto.insulina;
    }
    
    sumup = sumup / count;
    
    return sumup;
}

- (CGFloat) sumUpGlucemia: (NSMutableArray*) items {
    CGFloat sumup = 0;
    NSInteger count = 0;
    for (HealthDTO* dto in items) {
        if (dto.glucemia != 0) {count++;}
        sumup= sumup + dto.glucemia;
    }
    
    sumup = sumup / count;
    
    return sumup;
}

- (CGFloat) sumUpCarbohidratos: (NSMutableArray*) items {
    CGFloat sumup = 0;
    for (HealthDTO* dto in items) {
        sumup= sumup + dto.carbohidratos;
    }
    return sumup / items.count;
}

- (NSMutableArray*) filterItemsForDesayuno: (NSMutableArray*) items {
    
    NSMutableArray* hourItems = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if ([self timeframeForDate:dto.date]==1) {
            [hourItems addObject:dto];
        }
    }
    return hourItems;
}

- (NSMutableArray*) filterItemsForAlmuerzo: (NSMutableArray*) items {
    
    NSMutableArray* hourItems = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if ([self timeframeForDate:dto.date]==2) {
            [hourItems addObject:dto];
        }
    }
    return hourItems;
}

- (NSMutableArray*) filterItemsForMerienda: (NSMutableArray*) items {
    
    NSMutableArray* hourItems = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if ([self timeframeForDate:dto.date]==3) {
            [hourItems addObject:dto];
        }
    }
    return hourItems;
}

- (NSMutableArray*) filterItemsForCena: (NSMutableArray*) items {
    
    NSMutableArray* hourItems = [NSMutableArray new];
    for (HealthDTO* dto in items) {
        if ([self timeframeForDate:dto.date]==4) {
            [hourItems addObject:dto];
        }
    }
    return hourItems;
}


- (NSInteger) timeframeForDate: (NSDate*) date {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:date];
    NSInteger hour = [components hour];
    if (0<=hour&&hour<6)   { return 4;}
    if (6<=hour&&hour<12)  { return 1;}
    if (12<=hour&&hour<16) { return 2;}
    if (16<=hour&&hour<20) { return 3;}
    if (20<=hour&&hour<24) { return 4;}
    return 0;
}



- (NSMutableArray*) allWeekItems {
    
    NSArray* healthItems = [HealthManager sharedInstance].retrieveAllItems;
    NSMutableArray* weekItems = [NSMutableArray new];
    for (HealthDTO* dto in healthItems) {
        if ((-dto.date.timeIntervalSinceNow)<60*60*24*7) {
            [weekItems addObject:dto];
        }
    }
    return weekItems;
}

- (NSMutableArray*) allFortnightItems {
    
    NSArray* healthItems = [HealthManager sharedInstance].retrieveAllItems;
    NSMutableArray* fortItems = [NSMutableArray new];
    for (HealthDTO* dto in healthItems) {
        if ((-dto.date.timeIntervalSinceNow)<60*60*24*15) {
            [fortItems addObject:dto];
        }
    }
    return fortItems;
}

- (NSMutableArray*) allMonthItems {
    
    NSArray* healthItems = [HealthManager sharedInstance].retrieveAllItems;
    NSMutableArray* monthItems = [NSMutableArray new];
    for (HealthDTO* dto in healthItems) {
        if ((-dto.date.timeIntervalSinceNow)<60*60*24*30) {
            [monthItems addObject:dto];
        }
    }
    return monthItems;
}

- (NSMutableArray*) allPreviousMonthItems {
    
    NSArray* healthItems = [HealthManager sharedInstance].retrieveAllItems;
    NSMutableArray* monthItems = [NSMutableArray new];
    for (HealthDTO* dto in healthItems) {
        if ((-dto.date.timeIntervalSinceNow)>60*60*24*30&&(-dto.date.timeIntervalSinceNow)<60*60*24*60) {
            [monthItems addObject:dto];
        }
    }
    return monthItems;
}

- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) setUpScrollView {
    
    UIColor *darkGray =[UIColor colorWithRed:142/255.f green:142/255.f blue:147/255.f alpha:1];
    UIColor *paleBlue = [UIColor colorWithRed:232/255.f green:244/255.f blue:253/255.f alpha:1];
    UIColor *lightBlue = [UIColor colorWithRed:0/255.f green:155/255.f blue:238/255.f alpha:1];
    UIColor *lightGray = [UIColor colorWithRed:243/255.f green:244/255.f blue:245/255.f alpha:1];
    
    self.segmentedControl.tintColor = paleBlue;
    self.segmentedControl.backgroundColor =  lightGray;
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:13.0], NSFontAttributeName,
                                        lightBlue, NSForegroundColorAttributeName,
                                        paleBlue, NSBackgroundColorAttributeName, nil];
    
    
    [self.segmentedControl setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    NSDictionary *unselectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:13.0], NSFontAttributeName,
                                          darkGray, NSForegroundColorAttributeName,
                                          lightGray, NSBackgroundColorAttributeName, nil];
    [self.segmentedControl setTitleTextAttributes:unselectedAttributes forState:UIControlStateNormal];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
        UIViewController *nextVC = [segue destinationViewController];
        if ([nextVC isKindOfClass:[PresentiationViewController class]]) {
            PresentiationViewController *vc = (PresentiationViewController *) nextVC;
            vc.presentationItem = [self presentationItem];
        }
}

- (PresentationItem *) presentationItem
{
    PresentationItem *item = [PresentationItem new];
    item.title = @"Reporte de salud";
    return item;
}

@end
