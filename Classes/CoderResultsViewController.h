//
//  CoderResultsViewController.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/5/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoderCell.h"
#import "UIImage+Resizing.h"
#import "UITableViewCell+CustomNib.h"

@interface CoderResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  NSMutableArray *coders;
  UITableView *resultsTableView;
  NSPredicate *searchPredicate;
  NSArray *searchResults;
  NSInteger pageNumber;
  NSInteger searchPageNumber;
  NSString *lastSearchString;
  NSInteger totalWorkToBeDone;
  float incrementalAmount;
  float amountDone;
  BOOL progressBarDisplayed;
  BOOL gettingDataNow;
  UIProgressView *progressView;
  UIActionSheet *actionSheet;
}

@property (nonatomic, retain) NSMutableArray *coders;
@property (nonatomic, retain) IBOutlet UITableView *resultsTableView;
@property (nonatomic, copy) NSPredicate *searchPredicate;
@property (nonatomic, readonly) NSArray *searchResults;
@property (nonatomic, retain) NSString *lastSearchString;
@property (retain) UIActionSheet *actionSheet;

-(NSArray*)resultsForTableView:(UITableView*)table;
-(void)getNextPageOfCoderData:(UITableView*)aTableView;
-(NSInteger)currentPageNumber:(UITableView*)aTableView;
-(void)incrementCurrentPageNumber:(UITableView*)aTableView;
-(void)showProgressIndicator:(BOOL)fast andLength:(NSInteger)lengthOfTime;

@end
