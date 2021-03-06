//
//  CityResultsViewController.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/10/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "CityResultsViewController.h"
#import "CityDetailViewController.h"
#import "Constants.h"
#import "City.h"
#import "CompanyCell.h"
#import "Rails_RankrAppDelegate.h"
#import "Pluralizer.h"

@implementation CityResultsViewController

@synthesize resultsTable, data;

- (void)awakeFromNib
{
	networkQueue = [[ASINetworkQueue alloc] init];
  app = [UIApplication sharedApplication];
}

-(IBAction)refreshData {
  [self.data removeAllObjects];
  [self grabCodersInTheBackground];
}

#pragma mark -
#pragma mark ASIHTTPRequestJSON methods

- (void)grabCodersInTheBackground
{
  [self.view addSubview:spinner];
  [spinner startAnimating];
	ASIHTTPRequestJSON *request;
	request = [[[ASIHTTPRequestJSON alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@coders/all_cities.json",HOST_SERVER]]] autorelease];
	[networkQueue addOperation:request];
  [networkQueue go];
}

- (void)requestDone:(ASIHTTPRequestJSON *)request
{
  [self.data addObjectsFromArray:[request getCityCollection]];
  //NSLog(@"now we have %d",[self.data count]);
  [self.resultsTable reloadData];
  gettingDataNow = NO;
  [spinner stopAnimating];
  app.networkActivityIndicatorVisible = NO;
}

- (void)requestWentWrong:(ASIHTTPRequestJSON *)request
{
  NSError *error = [request error];
  NSLog(@"error occurred %@",[error localizedDescription]);
  gettingDataNow = NO;
  [spinner stopAnimating];
  app.networkActivityIndicatorVisible = NO;
}

-(void)getNextPageOfData:(UITableView*)aTableView {
  gettingDataNow = YES;
  [spinner startAnimating];
  app.networkActivityIndicatorVisible = YES;
  
  //NSLog(@"getting more data");
  NSString* queryString = [NSString stringWithFormat:@"page=%d",pageNumber];  
  NSString *coderPath = [NSString stringWithFormat:@"%@coders/all_cities.json?%@",
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
  self.data = [[NSMutableArray alloc] initWithCapacity:10];
  
  Rails_RankrAppDelegate* appDelegate = (Rails_RankrAppDelegate*)[[UIApplication sharedApplication] delegate];
  if([appDelegate haveNetworkAccess]) {
    [self grabCodersInTheBackground];
  }
  UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                 target:self action:@selector(refreshData)];
  
  self.navigationItem.rightBarButtonItem = refreshButton; 
  [self.resultsTable setRowHeight:64.0f];
  pageNumber = (int)1;  
}

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
                                     dequeueReusableCellWithIdentifier:@"City" ];
  if (cell == nil) {
    cell = (CompanyCell*)[[UITableViewCell alloc] initWithNibName:[NSString stringWithFormat:@"CompanyCell"] reuseIdentifier:[NSString stringWithFormat:@"City"]];
  }
  
  @try {
    City* city = ((City *)[self.data objectAtIndex:indexPath.row]);
    cell.nameLabel.text = city.name;
    cell.railsRankPointsLabel.text = city.formattedPoints; 
    cell.coderNumberLabel.text = [NSString stringWithFormat:@"%@ %@",city.numberOfCoders,[Pluralizer coderSuffix:city.numberOfCoders]];
    
    cell.rankLabel.text = city.rank;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  @catch (NSException * e) {
    NSLog(@"error creating company cell for cityresults controller %@",[e description]);
  }  
  //CGSize image_size = {50.0f, 50.0f};
  //UIImage* profile_image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",coder.imagePath]]]];
  //cell.profileImage.image = [UIImage imageOfSize:image_size fromImage:profile_image];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  City* city = [data objectAtIndex:indexPath.row];
  CityDetailViewController *cityDetailViewController = [[CityDetailViewController alloc] initWithNibName:@"CityDetailViewController" bundle:nil];
  cityDetailViewController.city = city;
  [self.navigationController pushViewController:cityDetailViewController animated:YES];
  [cityDetailViewController release];
  
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  City* city = [data objectAtIndex:indexPath.row];
  CityDetailViewController *cityDetailViewController = [[CityDetailViewController alloc] initWithNibName:@"CityDetailViewController" bundle:nil];
  cityDetailViewController.city = city;
  [self.navigationController pushViewController:cityDetailViewController animated:YES];
  [cityDetailViewController release];
  
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
