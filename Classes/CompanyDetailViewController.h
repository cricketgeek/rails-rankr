//
//  CompanyDetailViewController.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/5/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "BaseResultsViewController.h"

@class ASINetworkQueue;

@interface CompanyDetailViewController : BaseResultsViewController {
  Company* company;
  UILabel* companyTitle;
  UILabel* numberOfCodersLabel;
  UILabel* totalPointsLabel;
  UILabel* rankLabel;
  UITableView* resultsTable;
  ASINetworkQueue *networkQueue;
  UIProgressView *progressView;  
  NSMutableArray* data;
  UIApplication *app;  
}

@property (nonatomic, retain) Company *company;
@property (nonatomic, retain) IBOutlet UILabel *companyTitle;
@property (nonatomic, retain) IBOutlet UILabel *numberOfCodersLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalPointsLabel;
@property (nonatomic, retain) IBOutlet UILabel *rankLabel;
@property (nonatomic, retain) IBOutlet UITableView *resultsTable;
@property (nonatomic, retain) NSMutableArray *data;

- (void)grabCodersInTheBackground;
-(IBAction)refreshData:(id)sender;


@end
