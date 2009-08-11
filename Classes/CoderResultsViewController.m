//
//  CoderResultsViewController.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/5/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//
#import "CoderResultsViewController.h"
#import "CoderDetailViewController.h"
#import "ASIHTTPRequest+JSON.h"
#import "ASINetworkQueue.h"
#import "Coder.h"
#import "UIWebImageView.h"
#import "Constants.h"

@implementation CoderResultsViewController

@synthesize resultsTableView, searchPredicate, coders, lastSearchString, actionSheet;

- (void)awakeFromNib
{
	networkQueue = [[ASINetworkQueue alloc] init];
  app = [UIApplication sharedApplication];
}

-(IBAction)refreshData {
  pageNumber = (int)1;
  [self grabCodersInTheBackground];
  [self.resultsTableView reloadData];
}

-(NSArray*)searchResults {
  //  if(self.searchPredicate) {
  //    NSArray* coderSearchResults = [[NSArray arrayWithArray:self.coders] filteredArrayUsingPredicate:self.searchPredicate];
  //    return coderSearchResults;
  //  }
  //  else {
  return self.coders; 
  //  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  NSLog(@"I scrolled bitch! offset now %f height now %f", scrollView.contentOffset.y,scrollView.contentSize.height);
  if( (scrollView.contentOffset.y > (scrollView.contentSize.height - 320.0f)) && ([[self resultsForTableView:(UITableView*)scrollView] count] < 200)){
    if(!gettingDataNow) {
      [self incrementCurrentPageNumber:(UITableView*)scrollView];
      [self getNextPageOfCoderData:(UITableView*)scrollView];     
    }
  }
}

// This callback fakes progress via setProgress:
- (void) incrementBar: (id) timer
{
  amountDone += incrementalAmount;
  [progressView setProgress: (amountDone / totalWorkToBeDone)];
  if (amountDone > totalWorkToBeDone)
  {
    [self.actionSheet dismissWithClickedButtonIndex:0
     animated:YES];
    self.actionSheet = nil;
    [timer invalidate];
    progressBarDisplayed = NO;
  }
}

// Load the progress bar onto an action sheet backing
-(void)showProgressIndicator:(BOOL)fast andLength:(NSInteger)lengthOfTime
{
  if(!progressBarDisplayed) {
    progressBarDisplayed = YES;
    totalWorkToBeDone = lengthOfTime;
    incrementalAmount = fast ? 2.0f : 1.0f;
    amountDone = 0.0f;
    self.actionSheet = [[[UIActionSheet alloc]
                         initWithTitle:@"Downloading data. Please Wait\n\n\n"
                         delegate:nil cancelButtonTitle:nil destructiveButtonTitle: nil
                         otherButtonTitles: nil] autorelease];
    progressView = [[UIProgressView alloc]
                    initWithFrame:CGRectMake(0.0f, 40.0f, 220.0f, 90.0f)];
    [progressView setProgressViewStyle: UIProgressViewStyleDefault];
    [actionSheet addSubview:progressView];
    [progressView release];
    // Create the demonstration updates
    [progressView setProgress:(amountDone = 0.0f)];
    [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self
                                   selector:@selector(incrementBar:) userInfo: nil repeats: YES];
    [actionSheet showInView:self.view];
    progressView.center = CGPointMake(actionSheet.center.x,
                                      progressView.center.y);
    
  }
}

-(NSArray*)resultsForTableView:(UITableView*)table {
  return (table == self.resultsTableView) ? self.coders : self.searchResults;
}

-(NSInteger)currentPageNumber:(UITableView*)aTableView {
  return (aTableView == self.resultsTableView) ? pageNumber : searchPageNumber;
}

-(void)incrementCurrentPageNumber:(UITableView*)aTableView {
  if(aTableView == self.resultsTableView){
    pageNumber += 1;
  }
  else {
    searchPageNumber += 1; 
  }
}

-(void)getNextPageOfCoderData:(UITableView*)aTableView {
  gettingDataNow = YES;
  
  app.networkActivityIndicatorVisible = YES;
  
  NSLog(@"getting more data");
  NSInteger pageNumberToUse = [self currentPageNumber:aTableView];
  NSString* queryString = lastSearchString ? [NSString stringWithFormat:@"page=%d&search=%@",pageNumberToUse,lastSearchString] : [NSString stringWithFormat:@"page=%d",pageNumberToUse];  
  NSString *coderPath = [NSString stringWithFormat:@"%@coders.json?%@",
                         HOST_SERVER,
                         queryString];
 	ASIHTTPRequestJSON *request;
	request = [[[ASIHTTPRequestJSON alloc] initWithURL:[NSURL URLWithString:coderPath]] autorelease];
	[networkQueue addOperation:request];
  [networkQueue go];
}

/*dd
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

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
  [self.coders addObjectsFromArray:[request getCoderCollection]];
  NSLog(@"now we have %d",[self.coders count]);
  [self.resultsTableView reloadData];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  progressBarDisplayed = NO;
  gettingDataNow = NO;
  
  [networkQueue cancelAllOperations];
	[networkQueue setDownloadProgressDelegate:progressView];
	[networkQueue setRequestDidFinishSelector:@selector(requestDone:)];
	[networkQueue setDelegate:self];
  self.coders = [[NSMutableArray alloc] initWithCapacity:10];
  pageNumber = (int)1;  
  [self grabCodersInTheBackground];
  
  
  UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(refreshData)];
  
  self.navigationItem.rightBarButtonItem = refreshButton; 
  [self.resultsTableView setRowHeight:62.0f];
  [self.searchDisplayController.searchResultsTableView setRowHeight:62.0f];
  
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)atableView
 numberOfRowsInSection:(NSInteger)section {
  return [[self resultsForTableView:atableView] count];
}

- (UITableViewCell *)tableView:(UITableView *)atableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  CoderCell *cell = (CoderCell*)[atableView
                                 dequeueReusableCellWithIdentifier:@"Coder" ];
  
  if (cell == nil) {
    cell = (CoderCell*)[[UITableViewCell alloc] initWithNibName:[NSString stringWithFormat:@"CoderCell"] reuseIdentifier:[NSString stringWithFormat:@"Coder"]];
  }
  
  Coder* coder = ((Coder *)[[self resultsForTableView:atableView] objectAtIndex:indexPath.row]);
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
    //CGSize image_size = {50.0f, 50.0f};
    [cell.profileImage addSubview:webImage];
    //cell.profileImage.image = [UIImage imageOfSize:image_size fromImage:profile_image];
  }
  return cell;
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Coder* coder = [[self resultsForTableView:atableView] objectAtIndex:indexPath.row];
  CoderDetailViewController *coderDetailViewController = [[CoderDetailViewController alloc] initWithNibName:@"CoderDetailViewController" bundle:nil];
  coderDetailViewController.coder = coder;
  
  [self.parentViewController presentModalViewController:coderDetailViewController animated:YES];
  //[self.navigationController pushViewController:coderDetailViewController animated:YES];
  //[coderDetailViewController release];
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText {
  self.lastSearchString = searchText;
  self.searchPredicate = [NSPredicate predicateWithFormat:@"fullName BEGINSWITH %@",searchText];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
  searchPageNumber = 1;
  if([searchString length] > 2) {
    NSString *coderPath = [NSString stringWithFormat:@"%@coders.json?search=%@",
                           HOST_SERVER,
                           searchString];  
    ASIHTTPRequestJSON *request;
    request = [[[ASIHTTPRequestJSON alloc] initWithURL:[NSURL URLWithString:coderPath]] autorelease];
    [networkQueue addOperation:request];
    [networkQueue go];
    return YES;
    
  }
  else {
    return NO;
  }
  
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
  return YES;
}

- (void)dealloc {
  [coders release];
  [networkQueue release];
  [searchPredicate release];
  [super dealloc];
}


@end
