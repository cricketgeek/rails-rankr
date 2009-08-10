//
//  CoderDetailViewController.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/5/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "CoderDetailViewController.h"
#import "TwoLabelTableCell.h"
#import "UITableViewCell+CustomNib.h"

@implementation CoderDetailViewController

@synthesize coder, coderName, wwrRank, githubWatchers, railsRank, railsRankingsPoints, city, detailTableView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
   
 }


-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.title = self.coder.fullName;
  self.coderName.text = self.coder.fullName;
  self.city.text = self.coder.city;
  self.railsRank.text = self.coder.railsrank;
  self.wwrRank.text = self.coder.rank;
  self.railsRankingsPoints.text = self.coder.fullRank;
  
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)atableView
 numberOfRowsInSection:(NSInteger)section {
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)atableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  TwoLabelTableCell *cell = (TwoLabelTableCell*)[atableView
                                 dequeueReusableCellWithIdentifier:@"CoderDetails" ];
  
  if (cell == nil) {
    cell = (TwoLabelTableCell*)[[UITableViewCell alloc] initWithNibName:[NSString stringWithFormat:@"TwoLabelTableCell"] reuseIdentifier:[NSString stringWithFormat:@"CoderDetails"]];
  }
  
  switch (indexPath.row) {
    case 0:
      cell.leftLabel.text = [[NSString alloc] initWithString:@"Company"];
      cell.rightLabel.text = [self.coder companyName];
      break;
    case 1:
      cell.leftLabel.text = [[NSString alloc] initWithString:@"Website"];
      cell.rightLabel.text = [self.coder website];
      break;
    case 2:
      cell.leftLabel.text = [[NSString alloc] initWithString:@"Availability"];
      cell.rightLabel.text = [self.coder availabilityDescription];      
    default:
      break;
  }
  return cell;
}
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
  [coder release];
  [coderName release];
  [wwrRank release];
  [githubWatchers release];
  [railsRankingsPoints release];
  [railsRank release];
  [city release];
  [super dealloc];
}


@end
