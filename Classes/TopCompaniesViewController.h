//
//  TopCitiesViewController.h
//  Rails Rankr
//
//  Created by Mark Jones on 4/4/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TopCompaniesViewController : UITableViewController {
  NSMutableArray* cities;
  IBOutlet UITableView* tableView;
}

@property(nonatomic, retain) NSMutableArray* cities;
@property(nonatomic, retain) UITableView* tableView;

@end
