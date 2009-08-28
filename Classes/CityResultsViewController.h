//
//  CityResultsViewController.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/10/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Resizing.h"
#import "UITableViewCell+CustomNib.h"
#import "ASIHTTPRequest+JSON.h"
#import "ASINetworkQueue.h"
#import "BaseResultsViewController.h"

@interface CityResultsViewController : BaseResultsViewController <UITableViewDelegate, UITableViewDataSource>{
  UITableView* resultsTable;
  NSMutableArray* data;
  NSInteger pageNumber;
  ASINetworkQueue *networkQueue;
  UIProgressView *progressView;
  UIApplication *app;    
}

@property (nonatomic, retain) IBOutlet UITableView *resultsTable;
@property (nonatomic, retain) NSMutableArray *data;

-(IBAction)refreshData;
- (void)grabCodersInTheBackground;

@end
