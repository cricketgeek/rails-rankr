//
//  CoderFavoritesViewController.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/10/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "CoderFavoritesViewController.h"
#import "CoderDetailViewController.h"
#import "UIWebImageView.h"
#import "Constants.h"
#import "CoderCell.h"
#import "Coder.h"

@implementation CoderFavoritesViewController

@synthesize resultsTable, data;

- (void)awakeFromNib
{
	networkQueue = [[ASINetworkQueue alloc] init];
  app = [UIApplication sharedApplication];
}

-(IBAction)addFav:(id)sender {
  
  
  
}

-(IBAction)refreshData {
  pageNumber = (int)1;
  [self grabCodersInTheBackground];
  [self.resultsTable reloadData];
}

#pragma mark -
#pragma mark ASIHTTPRequestJSON methods

- (void)grabCodersInTheBackground
{
	ASIHTTPRequestJSON *request;
  NSLog(@"hitting: %@coders.json",HOST_SERVER);
	request = [[[ASIHTTPRequestJSON alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@coders.json",HOST_SERVER]]] autorelease];
	[networkQueue addOperation:request];
  [networkQueue go];
}

- (void)requestDone:(ASIHTTPRequestJSON *)request
{
  [self.data addObjectsFromArray:[request getCoderCollection]];
  NSLog(@"now we have %d",[self.data count]);
  [self.resultsTable reloadData];
  gettingDataNow = NO;
  app.networkActivityIndicatorVisible = NO;
}

- (void)requestWentWrong:(ASIHTTPRequestJSON *)request
{
  NSError *error = [request error];
  NSLog(@"error occurred %@",[error localizedDescription]);
  gettingDataNow = NO;
  app.networkActivityIndicatorVisible = NO;
}


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
  [networkQueue cancelAllOperations];
	[networkQueue setDownloadProgressDelegate:progressView];
	[networkQueue setRequestDidFinishSelector:@selector(requestDone:)];
	[networkQueue setDelegate:self];
  self.data = [[NSMutableArray alloc] initWithCapacity:10];
  
  
  UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(refreshData)];
  
  self.navigationItem.rightBarButtonItem = refreshButton; 
  [self.resultsTable setRowHeight:62.0f];
  //[self.searchDisplayController.searchResultsTableView setRowHeight:60.0f];
  pageNumber = (int)1;
}

#pragma mark -
#pragma mark TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)atableView
 numberOfRowsInSection:(NSInteger)section {
  return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)atableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  CoderCell *cell = (CoderCell*)[atableView
                                 dequeueReusableCellWithIdentifier:@"Coder" ];
  
  if (cell == nil) {
    cell = (CoderCell*)[[UITableViewCell alloc] initWithNibName:[NSString stringWithFormat:@"CoderCell"] reuseIdentifier:[NSString stringWithFormat:@"Coder"]];
  }
  
  Coder* coder = ((Coder *)[self.data objectAtIndex:indexPath.row]);
  cell.nameLabel.text = coder.fullName;
  NSLog(@"coder ranked at %@",coder.railsrank);
  cell.rankLabel.text = coder.railsrank;
  cell.cityLabel.text = coder.city;
  cell.railsRankPointsLabel.text = coder.fullRank; 
  [[cell.profileImage viewWithTag:57] removeFromSuperview];
  
  NSString* rawImagePath = [[NSString alloc] initWithString:coder.imagePath];
  NSString* defaultImage = [[NSString alloc] initWithString:@"/images/profile.png"];
  NSLog(@"matcher string %@",[rawImagePath substringToIndex:19]);
  if( [[rawImagePath substringToIndex:19] isEqualToString:defaultImage]) {
    cell.profileImage.image = [UIImage imageNamed:@"profile_small.png"];
  }
  else{
    NSString *url = [[NSString alloc] initWithString:coder.imagePath];
    UIWebImageView *webImage = [[UIWebImageView alloc] initWithFrame:CGRectMake(0,0,58,58) andUrl:url];
    webImage.tag = 57;
    [cell.profileImage addSubview:webImage];
  }
  return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"selected a fav coder");
  Coder* coder = [self.data objectAtIndex:indexPath.row];
  CoderDetailViewController *coderDetailViewController = [[CoderDetailViewController alloc] initWithNibName:@"CoderDetailViewController" bundle:nil];
  coderDetailViewController.coder = coder;
  [self.navigationController pushViewController:coderDetailViewController animated:YES];
  [coderDetailViewController release];  
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
    [super dealloc];
}


@end
