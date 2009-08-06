//
//  CoderResultsViewController.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/5/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "CoderResultsViewController.h"
#import "CoderDetailViewController.h"
#import "Response.h"
#import "Connection.h"
#import "Coder.h"
#import "ObjectiveSupport.h"

@implementation CoderResultsViewController

@synthesize resultsTableView, searchPredicate, coders, lastSearchString, actionSheet;

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

-(void)getAllCoderData{
  [self showProgressIndicator:YES andLength:6];
  self.coders = [NSMutableArray arrayWithArray:[Coder findAllRemote]];
  NSLog(@"found %d coders",[self.coders count]);
}

-(void)getNextPageOfCoderData:(UITableView*)aTableView {
  gettingDataNow = YES;
  UIApplication *app = [UIApplication sharedApplication];
  app.networkActivityIndicatorVisible = YES;
  
  NSLog(@"getting more data");
  NSInteger pageNumberToUse = [self currentPageNumber:aTableView];
  NSString* queryString = lastSearchString ? [NSString stringWithFormat:@"page=%d&search=%@",pageNumberToUse,lastSearchString] : [NSString stringWithFormat:@"page=%d",pageNumberToUse];
  
  NSString *coderPath = [NSString stringWithFormat:@"%@coders%@?%@",
                         [Coder getRemoteSite],
                         [Coder getRemoteProtocolExtension],
                         queryString];
  
  //send the response
  Response *res = [Connection get:coderPath];
  [self.coders addObjectsFromArray:[Coder fromJSONData:res.body]];
  NSLog(@"now have %d coders after scrolling to page %d",[self.coders count],pageNumber);
  [aTableView reloadData];
  gettingDataNow = NO;
  app.networkActivityIndicatorVisible = NO;
}

-(void)refreshData {
  [self getAllCoderData];
  [self.resultsTableView reloadData];
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  progressBarDisplayed = NO;
  gettingDataNow = NO;
  UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(refreshData)];
  
//  UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain
//                                                                   target:self action:@selector(refreshData)];
  
  self.navigationItem.rightBarButtonItem = refreshButton; 
  [self.resultsTableView setRowHeight:60.0f];
  [self.searchDisplayController.searchResultsTableView setRowHeight:60.0f];
  [self refreshData];
  pageNumber = (int)1;
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
    
    [cell retain];
  }
  
  Coder* coder = ((Coder *)[[self resultsForTableView:atableView] objectAtIndex:indexPath.row]);
  cell.nameLabel.text = coder.fullName;
  cell.rankLabel.text = coder.railsrank;
  cell.cityLabel.text = coder.city;
  cell.railsRankPointsLabel.text = coder.fullRank; 
  //CGSize image_size = {50.0f, 50.0f};
  //UIImage* profile_image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",coder.imagePath]]]];
  //cell.profileImage.image = [UIImage imageOfSize:image_size fromImage:profile_image];
  return cell;
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Coder* coder = [[self resultsForTableView:atableView] objectAtIndex:indexPath.row];
  CoderDetailViewController *coderDetailViewController = [[CoderDetailViewController alloc] initWithNibName:@"CoderDetailViewController" bundle:nil];
  coderDetailViewController.coder = coder;
  [self.navigationController pushViewController:coderDetailViewController animated:YES];
  [coderDetailViewController release];
}



 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */
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
    NSString *coderPath = [NSString stringWithFormat:@"%@coders%@?search=%@",
                           [Coder getRemoteSite],
                           [Coder getRemoteProtocolExtension],
                           searchString];
    
    //send the response
    Response *res = [Connection get:coderPath];
    self.coders = [Coder fromJSONData:res.body];
    NSLog(@"searched and found %d coders",[self.coders count]);
    
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
  [searchPredicate release];
  [super dealloc];
}


@end
