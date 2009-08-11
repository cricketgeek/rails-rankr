//
//  CoderDetailViewController.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/5/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coder.h"

@interface CoderDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  Coder* coder;
  UILabel* coderName;
  UILabel* wwrRank;
  UILabel* githubWatchers;
  UILabel* railsRankingsPoints;
  UILabel* railsRank;
  UILabel* city;
  UITableView* detailTableView;
  UIButton* wwrProfileUrlButton;
  UIButton* githubProfileUrlButton;
  UIButton* recommendWWRButton;
  
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
  NSManagedObjectContext *addingManagedObjectContext;    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;

@property (nonatomic, retain) Coder *coder;
@property (nonatomic, retain) IBOutlet UILabel *coderName;
@property (nonatomic, retain) IBOutlet UILabel *wwrRank;
@property (nonatomic, retain) IBOutlet UILabel *githubWatchers;
@property (nonatomic, retain) IBOutlet UILabel *railsRank;
@property (nonatomic, retain) IBOutlet UILabel *railsRankingsPoints;
@property (nonatomic, retain) IBOutlet UILabel *city;
@property (nonatomic, retain) IBOutlet UITableView *detailTableView;
@property (nonatomic, retain) IBOutlet UIButton *wwrProfileUrlButton;
@property (nonatomic, retain) IBOutlet UIButton *githubProfileUrlButton;
@property (nonatomic, retain) IBOutlet UIButton *recommendWWRButton;

-(IBAction)goToWWRProfile:(id)sender;
-(IBAction)goToGithubProfile:(id)sender;
-(IBAction)recommendOnWWR:(id)sender;
-(IBAction)saveAsFavorite;

@end
