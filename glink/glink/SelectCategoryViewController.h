//
//  SelectCategoryViewController.h
//  glink
//
//  Created by Federico Bustos Fierro on 4/2/17.
//  Copyright © 2017 Glink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCategoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *categories;
@property (nonatomic, copy) NSString *key;
@end
