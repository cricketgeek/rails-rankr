//
//  CompanyResultsViewController.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/5/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseResultsViewController.h"
#import "UIImage+Resizing.h"
#import "UITableViewCell+CustomNib.h"

@class ASINetworkQueue;

@interface CompanyResultsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
  UITableView* resultsTable;
  NSMutableArray* data;
  NSInteger pageNumber;
  NSInteger searchPageNumber;
  BOOL gettingDataNow;
  ASINetworkQueue *networkQueue;
  UIProgressView *progressView;
  UIApplication *app;  
  NSString *lastSearchString;  
}

@property (nonatomic, retain) IBOutlet UITableView *resultsTable;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSString *lastSearchString;

-(IBAction)refreshData;
- (void)grabCodersInTheBackground;
-(NSInteger)currentPageNumber:(UITableView*)aTableView;

@end
