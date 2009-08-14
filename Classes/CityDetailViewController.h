//
//  CityDetailViewController.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/14/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"
#import "BaseResultsViewController.h"

@class ASINetworkQueue;

@interface CityDetailViewController : BaseResultsViewController {
  City* city;
  UILabel* cityTitle;
  UILabel* numberOfCodersLabel;
  UILabel* totalPointsLabel;
  UILabel* rankLabel;
  UITableView* resultsTable;
  ASINetworkQueue *networkQueue;
  UIProgressView *progressView;  
  NSMutableArray* data;
  UIApplication *app;  
}

@property (nonatomic, retain) City *city;
@property (nonatomic, retain) IBOutlet UILabel *cityTitle;
@property (nonatomic, retain) IBOutlet UILabel *numberOfCodersLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalPointsLabel;
@property (nonatomic, retain) IBOutlet UILabel *rankLabel;
@property (nonatomic, retain) IBOutlet UITableView *resultsTable;
@property (nonatomic, retain) NSMutableArray *data;

- (void)grabCodersInTheBackground;
-(IBAction)refreshData;

@end