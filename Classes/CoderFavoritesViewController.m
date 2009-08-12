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
#import "Rails_RankrAppDelegate.h"
#import "CoderModelsConverter.h"
#import "CoreCoder.h"

@implementation CoderFavoritesViewController

@synthesize resultsTable, data;
@synthesize fetchedResultsController, managedObjectContext, addingManagedObjectContext;

- (void)awakeFromNib
{
	networkQueue = [[ASINetworkQueue alloc] init];
  app = [UIApplication sharedApplication];
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
  NSArray* existingFavorites = [[self fetchedResultsController] fetchedObjects];
  if(existingFavorites) {
    NSMutableArray* localCoders = [[NSMutableArray alloc] initWithCapacity:10];
    for (CoreCoder* coder in existingFavorites) {
      [localCoders addObject:coder.coder_id];
    }
    
    NSString* coder_params = [localCoders componentsJoinedByString:@","];
    NSLog(@"passing params as %@",[NSString stringWithFormat:@"%@coders/get_coders_by_ids.json?coders=%@",
                                   HOST_SERVER,
                                   coder_params]);
    request = [[[ASIHTTPRequestJSON alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@coders/get_coders_by_ids.json?coders=%@",
                                                                             HOST_SERVER,
                                                                             coder_params]]] autorelease];
    [networkQueue addOperation:request];
    [networkQueue go];
    
  }
}

- (void)requestDone:(ASIHTTPRequestJSON *)request
{
  [self.data addObjectsFromArray:[request getCoderCollection]];
  NSLog(@"data objects from server we have %d",[self.data count]);
  
  for (Coder* coder in self.data) {
    for (CoreCoder* coreCoder in [[self fetchedResultsController] fetchedObjects]) {
      if([coreCoder.coder_id isEqualToString:coder.coderId]) {
        NSLog(@"updated date: %@",coder.updatedAt);
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];//%a, %d %b %Y %H:%M:%S %Z"];
        NSDate* serverDate = [dateFormatter dateFromString:coder.updatedAt];
        if([coreCoder.updatedAt compare:serverDate] == NSOrderedAscending) {
          coreCoder.updatedAt = serverDate;
          coreCoder.railsRankPoints = coder.fullRank;
          coreCoder.railsRank = coder.railsrank;
          coreCoder.imagePath = coder.imagePath;
          coreCoder.company = coder.companyName;
          coreCoder.city = coder.city;
          coreCoder.wwrProfileUrl = coder.wwrProfileUrl;
          coreCoder.availability = [[NSNumber alloc] initWithBool:coder.available];
          coreCoder.githubUrl = coder.githubUrl;
          coreCoder.githubWatchers = coder.githubWatchers;
          
          //we have a newer version on the server
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
      }
    }
  }
  
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

-(void)viewWillAppear:(BOOL)animated {
  
  NSError* error;
  if([[self fetchedResultsController] performFetch:&error]) {
    NSLog(@"got results from core data");
    [self grabCodersInTheBackground];
  }
  else {
    NSLog(@"somefink went wrong Horace!");
  }
  
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
  [networkQueue cancelAllOperations];
	[networkQueue setDownloadProgressDelegate:progressView];
	[networkQueue setRequestDidFinishSelector:@selector(requestDone:)];
	[networkQueue setDelegate:self];
  self.data = [[NSMutableArray alloc] initWithCapacity:10];
  
  UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                 target:self action:@selector(refreshData)];
  
  self.navigationItem.rightBarButtonItem = refreshButton;
  [self.resultsTable setRowHeight:62.0f];
  pageNumber = (int)1;  
  Rails_RankrAppDelegate* delegate = (Rails_RankrAppDelegate*)[[UIApplication sharedApplication] delegate];
  self.managedObjectContext = delegate.managedObjectContext;
}

#pragma mark -
#pragma mark TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)atableView
 numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)atableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  CoderCell *cell = (CoderCell*)[atableView
                                 dequeueReusableCellWithIdentifier:@"Coder" ];
  
  if (cell == nil) {
    cell = (CoderCell*)[[UITableViewCell alloc] initWithNibName:[NSString stringWithFormat:@"CoderCell"] reuseIdentifier:[NSString stringWithFormat:@"Coder"]];
  }
  CoreCoder *coder = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.nameLabel.text = coder.fullName;
  cell.rankLabel.text = coder.railsRank;
  cell.cityLabel.text = coder.city;
  cell.railsRankPointsLabel.text = [coder formattedRankPoints]; 
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
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"selected a fav coder");
  CoreCoder* coreCoder = (CoreCoder *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
  Coder* coder = [[Coder alloc] init];
  [CoderModelsConverter coderFromCoreCoder:coder andCoreCoder:coreCoder];
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the managed object for the given index path
		NSManagedObjectContext *context = [[self fetchedResultsController] managedObjectContext];
		[context deleteObject:[[self fetchedResultsController] objectAtIndexPath:indexPath]];
		// Save the context.
		NSError *error;
		if (![context save:&error]) {
			// Handle the error...
      NSLog(@"Failed to delete that guy, but why? %@",[error localizedDescription]);
		}
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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


- (NSFetchedResultsController *)fetchedResultsController {
  
  if (fetchedResultsController != nil) {
    return fetchedResultsController;
  }
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoreCoder" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"railsRankPoints" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	// Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:@"Root"];
  aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	return fetchedResultsController;
}    



- (void)dealloc {
  [fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}


@end
