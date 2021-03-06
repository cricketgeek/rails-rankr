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

@synthesize resultsTableView, infoView, searchPredicate, coders, coderSearchResults, lastSearchString, actionSheet;
@synthesize doneBarButtonItem, infoBarButtonItem;

- (void)awakeFromNib
{
	networkQueue = [[ASINetworkQueue alloc] init];
  app = [UIApplication sharedApplication];
}

-(IBAction)refreshData {
  pageNumber = (int)1;
  [self.coders removeAllObjects];
  [self grabCodersInTheBackground];
  
}

-(NSArray*)searchResults {
  return self.coderSearchResults;      
}

-(void)clearSearchResults {
  
  [self.coderSearchResults release];
  self.coderSearchResults = [[NSMutableArray alloc] initWithCapacity:10];
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  //NSLog(@"I scrolled! offset now %f height now %f", scrollView.contentOffset.y,scrollView.contentSize.height);
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
  return (table == self.resultsTableView) ? self.coders : self.coderSearchResults;
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
    [spinner startAnimating];
  gettingDataNow = YES;
  app.networkActivityIndicatorVisible = YES;
  NSInteger pageNumberToUse = [self currentPageNumber:aTableView];
  NSString* queryString = searching ? [NSString stringWithFormat:@"page=%d&search=%@",pageNumberToUse,lastSearchString] : [NSString stringWithFormat:@"page=%d",pageNumberToUse];  
  NSString *coderPath = [NSString stringWithFormat:@"%@coders.json?%@",
                         HOST_SERVER,
                         queryString];
 	ASIHTTPRequestJSON *request;
	request = [[[ASIHTTPRequestJSON alloc] initWithURL:[NSURL URLWithString:coderPath]] autorelease];
  [networkQueue addOperation:request];
  [networkQueue go];
}

#pragma mark -
#pragma mark ASIHTTPRequestJSON methods

- (void)grabCodersInTheBackground
{
  [self.view addSubview:spinner];
  [spinner startAnimating];
	ASIHTTPRequestJSON *request;
  
	request = [[[ASIHTTPRequestJSON alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@coders.json",HOST_SERVER]]] autorelease];
	[request setTimeOutSeconds:20];
  [networkQueue addOperation:request];
  [networkQueue go];
}

- (void)requestDone:(ASIHTTPRequestJSON *)request
{
  if(searching) {
    [self.coderSearchResults addObjectsFromArray:[request getCoderCollection]];
    //NSLog(@"now we have %d coders from search",[self.coderSearchResults count]);
    newSearchResults = YES;
    [self.searchDisplayController.searchResultsTableView reloadData];
  }
  else {
    [self.coders addObjectsFromArray:[request getCoderCollection]];
    [self.resultsTableView reloadData];
    //NSLog(@"now we have %d coders",[self.coders count]);
  }
  [spinner stopAnimating];
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
  newSearchResults = NO;
  mainViewFlipped = NO;
  [networkQueue cancelAllOperations];
	[networkQueue setDownloadProgressDelegate:progressView];
	[networkQueue setRequestDidFinishSelector:@selector(requestDone:)];
	[networkQueue setDelegate:self];
  self.coders = [[NSMutableArray alloc] initWithCapacity:10];
  self.coderSearchResults = [[NSMutableArray alloc] initWithCapacity:10];
  pageNumber = (int)1;  
  UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                 target:self action:@selector(refreshData)];
  NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"SuccessFormula" owner:self options:nil];
  UIView* successFormulaView = [views objectAtIndex:0];
  successFormulaView.tag = 55;
  
  UIImageView* backgroundView = (UIImageView*)[self.view viewWithTag:23];
  [self.view insertSubview:successFormulaView belowSubview:backgroundView];
  
  self.navigationItem.rightBarButtonItem = refreshButton;
  
  UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
  [infoButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
  

  self.infoBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
  [self.navigationItem setLeftBarButtonItem:infoBarButtonItem animated:NO];

  
  self.doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleView)];
  
  Rails_RankrAppDelegate* appDelegate = (Rails_RankrAppDelegate*)[[UIApplication sharedApplication] delegate];
  if([appDelegate haveNetworkAccess]) {
    [self grabCodersInTheBackground];    
  }
  
  
  [self.resultsTableView setRowHeight:64.0f];
  [self.searchDisplayController.searchResultsTableView setRowHeight:64.0f];
}

-(void)toggleView {
  
  BOOL showDoneButton;
  
  NSLog(@"flip it!");
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:1];
  
  UIViewAnimationTransition direction;
  
  if(mainViewFlipped) {
    direction = UIViewAnimationTransitionFlipFromLeft;
    mainViewFlipped = NO;
    showDoneButton = NO;
  }
  else {
    direction = UIViewAnimationTransitionFlipFromRight;
    mainViewFlipped = YES;
    showDoneButton = YES;
    
  }
  [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:4];
  [UIView setAnimationTransition:direction forView:self.view cache:YES];
  [UIView commitAnimations];
  
  if (showDoneButton) {
    [self.navigationItem setLeftBarButtonItem:self.doneBarButtonItem animated:YES];
  }
  else {
    [self.navigationItem setLeftBarButtonItem:self.infoBarButtonItem animated:YES];
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
  [self.coders release];
  [self.coderSearchResults release];
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
  
  @try {
    Coder* coder = ((Coder *)[[self resultsForTableView:atableView] objectAtIndex:indexPath.row]);
    
    if(coder != nil) {
      
      cell.nameLabel.text = coder.wholeName;
      NSLog(@"coder %@ ranked at %@ from %@",coder.wholeName,coder.railsrank, coder.city);
      cell.rankLabel.text = coder.railsrank;
      if(coder.city != nil) {
        cell.cityLabel.text = coder.city;    
      }
      else {
        cell.cityLabel.text = [NSString string];
      }
      cell.railsRankPointsLabel.text = coder.formattedFullRank; //coder.fullRank; 
      [[cell.profileImage viewWithTag:57] removeFromSuperview];
      
      if(coder.imagePath != nil) {
        NSString* rawImagePath = [[NSString alloc] initWithString:coder.imagePath];
        NSString* defaultImage = [[NSString alloc] initWithString:@"/images/profile.png"];
        //NSLog(@"matcher string %@",[rawImagePath substringToIndex:19]);
        if( rawImagePath != nil && [[rawImagePath substringToIndex:19] isEqualToString:defaultImage]) {
          cell.profileImage.image = [UIImage imageNamed:@"profile_small.png"];
        }
        else{
          NSString *url = [[NSString alloc] initWithString:coder.imagePath];
          UIWebImageView *webImage = [[UIWebImageView alloc] initWithFrame:CGRectMake(0,0,60,56) andUrl:url];
          webImage.tag = 57;
          [cell.profileImage addSubview:webImage];
        }
        
      }
      cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
      
    }
    
  }
  @catch (NSException * e) {
    NSLog(@"error building cell %@",[e description]);
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  
  Coder* coder = [[self resultsForTableView:tableView] objectAtIndex:indexPath.row];
  CoderDetailViewController *coderDetailViewController = [[CoderDetailViewController alloc] initWithNibName:@"CoderDetailViewController" bundle:nil];
  coderDetailViewController.coder = coder;
  
  [self.navigationController pushViewController:coderDetailViewController animated:YES];
  [coderDetailViewController release]; 
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Coder* coder = [[self resultsForTableView:atableView] objectAtIndex:indexPath.row];
  CoderDetailViewController *coderDetailViewController = [[CoderDetailViewController alloc] initWithNibName:@"CoderDetailViewController" bundle:nil];
  coderDetailViewController.coder = coder;
  
  [self.navigationController pushViewController:coderDetailViewController animated:YES];
  [coderDetailViewController release];
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText {
  self.lastSearchString = searchText;
  self.searchPredicate = [NSPredicate predicateWithFormat:@"fullName BEGINSWITH %@",searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  searching = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  searchPageNumber = 1;
  [self clearSearchResults];
  NSString *coderPath = [NSString stringWithFormat:@"%@coders.json?search=%@",
                         HOST_SERVER,
                         [self.lastSearchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];  
  ASIHTTPRequestJSON *request;
  request = [[[ASIHTTPRequestJSON alloc] initWithURL:[NSURL URLWithString:coderPath]] autorelease];
  [networkQueue addOperation:request];
  [networkQueue go];
  searching = YES;
  newSearchResults = YES;
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
  if(newSearchResults) {
    newSearchResults = NO;
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
  [lastSearchString release];
  [coderSearchResults release];
  [self.infoBarButtonItem release];
  [self.doneBarButtonItem release];
  [networkQueue release];
  [searchPredicate release];
  [super dealloc];
}


@end
