//
//  CompanyResultsViewController.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/5/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//
#import "ASIHTTPRequest+JSON.h"
#import "ASINetworkQueue.h"
#import "CompanyResultsViewController.h"
#import "CompanyDetailViewController.h"
#import "Company.h"
#import "CompanyCell.h"
#import "Constants.h"

@implementation CompanyResultsViewController

@synthesize resultsTable, data, lastSearchString;

- (void)awakeFromNib
{
	networkQueue = [[ASINetworkQueue alloc] init];
  app = [UIApplication sharedApplication];
}

-(IBAction)refreshData {
  pageNumber = (int)1;
  [self.data removeAllObjects];
  [self grabCodersInTheBackground];
}

#pragma mark -
#pragma mark ASIHTTPRequestJSON methods

- (void)grabCodersInTheBackground
{
	ASIHTTPRequestJSON *request;
	request = [[[ASIHTTPRequestJSON alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@coders/all_companies.json",HOST_SERVER]]] autorelease];
	[networkQueue addOperation:request];
  [networkQueue go];
}

- (void)requestDone:(ASIHTTPRequestJSON *)request
{
  [self.data addObjectsFromArray:[request getCompanyCollection]];
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

-(NSInteger)currentPageNumber:(UITableView*)aTableView {
  return (aTableView == self.resultsTable) ? pageNumber : searchPageNumber;
}

-(void)incrementCurrentPageNumber:(UITableView*)aTableView {
  if(aTableView == self.resultsTable){
    pageNumber += 1;
  }
  else {
    searchPageNumber += 1; 
  }
}

-(void)getNextPageOfData:(UITableView*)aTableView {
  gettingDataNow = YES;
  
  app.networkActivityIndicatorVisible = YES;
  
  NSLog(@"getting more data");
  NSInteger pageNumberToUse = [self currentPageNumber:aTableView];
  NSString* queryString = lastSearchString ? [NSString stringWithFormat:@"page=%d&search=%@",pageNumberToUse,lastSearchString] : [NSString stringWithFormat:@"page=%d",pageNumberToUse];  
  NSString *coderPath = [NSString stringWithFormat:@"%@coders/all_companies.json?%@",
                         HOST_SERVER,
                         queryString];
 	ASIHTTPRequestJSON *request;
	request = [[[ASIHTTPRequestJSON alloc] initWithURL:[NSURL URLWithString:coderPath]] autorelease];
	[networkQueue addOperation:request];
  [networkQueue go];
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
  self.data = [[NSMutableArray alloc] initWithCapacity:100];
  [self grabCodersInTheBackground];
  
  UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                 target:self action:@selector(refreshData)];
  
  self.navigationItem.rightBarButtonItem = refreshButton; 
  [self.resultsTable setRowHeight:64.0f];
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
  return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)atableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  CompanyCell *cell = (CompanyCell*)[atableView
                                 dequeueReusableCellWithIdentifier:@"Company" ];
  if (cell == nil) {
    cell = (CompanyCell*)[[UITableViewCell alloc] initWithNibName:[NSString stringWithFormat:@"CompanyCell"] reuseIdentifier:[NSString stringWithFormat:@"Company"]];
  }
  
  Company* company = ((Company *)[self.data objectAtIndex:indexPath.row]);
  cell.nameLabel.text = company.name;
  cell.rankLabel.text = company.rank;
  cell.railsRankPointsLabel.text = company.formattedPoints;
  cell.coderNumberLabel.text = company.numberOfCoders;

  //CGSize image_size = {50.0f, 50.0f};
  //UIImage* profile_image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",coder.imagePath]]]];
  //cell.profileImage.image = [UIImage imageOfSize:image_size fromImage:profile_image];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Company* company = [data objectAtIndex:indexPath.row];
  CompanyDetailViewController *companyDetailViewController = [[CompanyDetailViewController alloc] initWithNibName:@"CompanyDetailViewController" bundle:nil];
  companyDetailViewController.company = company;
  [self.navigationController pushViewController:companyDetailViewController animated:YES];
  [companyDetailViewController release];
  
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  Company* company = [data objectAtIndex:indexPath.row];
  CompanyDetailViewController *companyDetailViewController = [[CompanyDetailViewController alloc] initWithNibName:@"CompanyDetailViewController" bundle:nil];
  companyDetailViewController.company = company;
  [self.navigationController pushViewController:companyDetailViewController animated:YES];
  [companyDetailViewController release];
  
}


// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//  // Return NO if you do not want the specified item to be editable.
//  return YES;
//}


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



- (void)dealloc {
  [self.data release];
  [lastSearchString release];
  [progressView release];
  [networkQueue release];
  [super dealloc];
}


@end
