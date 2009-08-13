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
#import "UIWebImageView.h"
#import "Rails_RankrAppDelegate.h"
#import "CoderModelsConverter.h"
#import "CoreCoder.h"


@implementation CoderDetailViewController

@synthesize coder, coderName, wwrRank, githubWatchers, railsRank, railsRankingsPoints, city, detailTableView,wwrProfileUrlButton,githubProfileUrlButton,recommendWWRButton;;
@synthesize fetchedResultsController, managedObjectContext, addingManagedObjectContext;

-(IBAction)goToWWRProfile:(id)sender{
  NSLog(@"going to WWR profile for %@",self.coder.fullName);
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.coder.wwrProfileUrl]];
}

-(IBAction)goToGithubProfile:(id)sender {
  NSLog(@"going to github profile for %@",self.coder.fullName);
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.coder.githubUrl]];  
}

-(IBAction)recommendOnWWR:(id)sender {
  NSLog(@"recommending %@",self.coder.fullName);
  if([self.coder hasWWRUrl]) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.coder wwrRecommendUrl]]]; 
  }
}


-(IBAction)saveAsFavorite {  
  CoreCoder* coreCoder = (CoreCoder *)[NSEntityDescription insertNewObjectForEntityForName:@"CoreCoder" inManagedObjectContext:[self managedObjectContext]];  
  [CoderModelsConverter coreCoderFromCoder:coreCoder andCoder:self.coder];
  NSError *error;
  if (![[self managedObjectContext] save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
  }
  else {
    //turn fav button into unfavorite
    NSLog(@"saved favorite");
  }
  
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.detailTableView setBackgroundColor:[UIColor clearColor]];
  Rails_RankrAppDelegate* delegate = (Rails_RankrAppDelegate*)[[UIApplication sharedApplication] delegate];
  self.managedObjectContext = delegate.managedObjectContext;
  
  UIBarButtonItem *addFavButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"favs-white.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(saveAsFavorite)]; 
  self.navigationItem.rightBarButtonItem = addFavButton; 
}


-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.title = self.coder.fullName;
  self.coderName.text = self.coder.fullName;
  self.city.text = self.coder.city;
  self.railsRank.text = self.coder.railsrank;
  self.wwrRank.text = self.coder.rank;
  self.railsRankingsPoints.text = self.coder.formattedFullRank;
  self.githubWatchers.text = self.coder.githubWatchers;
  
  NSString* rawImagePath = [[NSString alloc] initWithString:coder.imagePath];
  NSString* defaultImage = [[NSString alloc] initWithString:@"/images/profile.png"];
  NSLog(@"matcher string %@",[rawImagePath substringToIndex:19]);
  if( [[rawImagePath substringToIndex:19] isEqualToString:defaultImage]) {
    NSLog(@"just using background here now");
  }
  else{
    NSString *url = [[NSString alloc] initWithString:coder.imagePath];
    UIWebImageView *webImage = [[UIWebImageView alloc] initWithFrame:CGRectMake(20,23,82,84) andUrl:url];
    webImage.tag = 57;
    [self.view addSubview:webImage];
  }
  
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
      if([[self.coder website] isKindOfClass:[NSString class]]){
        cell.rightLabel.text = [self.coder website];    
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
      }
      else {
        cell.rightLabel.text = [NSString string];
      }
      break;
    case 2:
      cell.leftLabel.text = [[NSString alloc] initWithString:@"Availability"];
      cell.rightLabel.text = [self.coder availabilityDescription];
      if(coder.available){
        [cell.rightLabel setTextColor:[UIColor colorWithRed:0.063 green:.392 blue:0.020 alpha:1.0]];
      }
      else{
        [cell.rightLabel setTextColor:[UIColor colorWithRed:0.85 green:0.3 blue:0.2 alpha:1.0]];
        
      }
      
    default:
      break;
  }
  return cell;
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if(indexPath.row == 1) {
    if([self.coder hasWebSite]) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.coder website]]]; 
    }
  }
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
