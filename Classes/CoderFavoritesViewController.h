//
//  CoderFavoritesViewController.h
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

@interface CoderFavoritesViewController : BaseResultsViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
  NSManagedObjectContext *addingManagedObjectContext;  
  UITableView* resultsTable;
  NSMutableArray* data;
  NSInteger pageNumber;
  ASINetworkQueue *networkQueue;
  UIProgressView *progressView;
  UIApplication *app;    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;
@property (nonatomic, retain) IBOutlet UITableView *resultsTable;
@property (nonatomic, retain) NSMutableArray *data;

-(IBAction)addFav:(id)sender;
- (void)grabCodersInTheBackground;
-(IBAction)refreshData;


@end
