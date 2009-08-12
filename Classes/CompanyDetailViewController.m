//
//  CompanyDetailViewController.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/5/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "CoderDetailViewController.h"
#import "Coder.h"
#import "Company.h"
#import "CoderCell.h"
#import "UIImage+Resizing.h"
#import "UITableViewCell+CustomNib.h"
#import "ASIHTTPRequest+JSON.h"
#import "ASINetworkQueue.h"
#import "UIWebImageView.h"
#import "Constants.h"


@implementation CompanyDetailViewController

@synthesize company,companyTitle,numberOfCodersLabel,rankLabel,totalPointsLabel,resultsTable, data;

-(IBAction)refreshData {
  [self grabCodersInTheBackground];
  [self.resultsTable reloadData];
}

#pragma mark -
#pragma mark ASIHTTPRequestJSON methods

- (void)grabCodersInTheBackground
{
  NSLog(@"Making a request to %@",[NSString stringWithFormat:@"%@coders.json?search=%@",HOST_SERVER,self.company.name]);
	
  NSString *coderPath = [[NSString stringWithFormat:@"%@coders.json?search=%@",
                         HOST_SERVER,
                         self.company.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  
  ASIHTTPRequestJSON *request;
  request = [[[ASIHTTPRequestJSON alloc] initWithURL:[NSURL URLWithString:coderPath]] autorelease]; 
  
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  networkQueue = [[ASINetworkQueue alloc] init];
  app = [UIApplication sharedApplication];
  self.companyTitle.text = self.company.name;
  self.totalPointsLabel.text = self.company.points;
  self.rankLabel.text = self.company.rank;
  self.numberOfCodersLabel.text = [NSString stringWithFormat:@"%@ coders",self.company.numberOfCoders];
  
  [networkQueue cancelAllOperations];
	[networkQueue setDownloadProgressDelegate:progressView];
	[networkQueue setRequestDidFinishSelector:@selector(requestDone:)];
	[networkQueue setDelegate:self];
  self.data = [[NSMutableArray alloc] initWithCapacity:10];
  [self grabCodersInTheBackground];
  
  UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(refreshData)];
  
  self.navigationItem.rightBarButtonItem = refreshButton; 
  [self.resultsTable setRowHeight:62.0f];

  
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


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
  Coder* coder = [self.data objectAtIndex:indexPath.row];
  CoderDetailViewController *coderDetailViewController = [[CoderDetailViewController alloc] initWithNibName:@"CoderDetailViewController" bundle:nil];
  coderDetailViewController.coder = coder;
  
  //[self.parentViewController presentModalViewController:coderDetailViewController animated:YES];
  [self.navigationController pushViewController:coderDetailViewController animated:YES];
  [coderDetailViewController release];
}


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
  [company release];
  [data release];
  [super dealloc];
}


@end
