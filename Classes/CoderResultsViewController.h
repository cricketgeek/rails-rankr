//
//  CoderResultsViewController.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/5/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseResultsViewController.h"
#import "CoderCell.h"
#import "UIImage+Resizing.h"
#import "UITableViewCell+CustomNib.h"
#import "Reachability.h"

@class ASINetworkQueue;

@interface CoderResultsViewController : BaseResultsViewController < UITableViewDataSource, UITableViewDelegate> {
  NSMutableArray *coders;
  UITableView *resultsTableView;
  NSPredicate *searchPredicate;
  NSArray *searchResults;
  NSMutableArray* coderSearchResults;
  BOOL newSearchResults;
  NSInteger pageNumber;
  NSInteger searchPageNumber;
  NSString *lastSearchString;
  NSInteger totalWorkToBeDone;
  float incrementalAmount;
  float amountDone;
  BOOL progressBarDisplayed;
  ASINetworkQueue *networkQueue;
  UIProgressView *progressView;
  UIActionSheet *actionSheet;
  UIApplication *app;
  BOOL searching;
  UIView* infoView;
  Reachability* hostReach;
}

@property (nonatomic, retain) NSMutableArray *coders;
@property (nonatomic, retain) NSMutableArray *coderSearchResults;
@property (nonatomic, retain) IBOutlet UITableView *resultsTableView;
@property (nonatomic, copy) NSPredicate *searchPredicate;
@property (nonatomic, readonly) NSArray *searchResults;
@property (nonatomic, retain) NSString *lastSearchString;
@property (retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) IBOutlet UIView *infoView;

-(NSArray*)resultsForTableView:(UITableView*)table;
-(void)getNextPageOfCoderData:(UITableView*)aTableView;
-(void)grabCodersInTheBackground;
-(NSInteger)currentPageNumber:(UITableView*)aTableView;
-(void)incrementCurrentPageNumber:(UITableView*)aTableView;
-(void)showProgressIndicator:(BOOL)fast andLength:(NSInteger)lengthOfTime;
-(IBAction)refreshData;

//-(IBAction)showInfoView;
//-(IBAction)closeInfoView;

@end
