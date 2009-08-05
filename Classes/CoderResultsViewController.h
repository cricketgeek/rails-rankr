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

@interface CoderResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate> {
  NSMutableArray *coders;
  UITableView *resultsTableView;
  NSPredicate *searchPredicate;
  NSArray *searchResults;
  NSInteger pageNumber;
  NSString *lastSearchString;
}
@property (nonatomic, retain) NSMutableArray *coders;
@property (nonatomic, retain) IBOutlet UITableView *resultsTableView;
@property (nonatomic, copy) NSPredicate *searchPredicate;
@property (nonatomic, readonly) NSArray *searchResults;
@property (nonatomic, retain) NSString *lastSearchString;

-(NSArray*)resultsForTableView:(UITableView*)table;
- (CoderCell*)createCoderCellFromNib;

@end
