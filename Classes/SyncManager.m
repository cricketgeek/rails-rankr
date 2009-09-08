//
//  SyncManager.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/12/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "SyncManager.h"
#import "Constants.h"
#import "CoderCell.h"
#import "Coder.h"
#import "Rails_RankrAppDelegate.h"
#import "CoderModelsConverter.h"


@implementation SyncManager

@synthesize data, favoritesTabBarItem, fetchedResultsController, managedObjectContext, addingManagedObjectContext;


-(id)init {
  if(self = [super init]){
    favsChanged = 0;
    networkQueue = [[ASINetworkQueue alloc] init];
    app = [UIApplication sharedApplication];    
    [networkQueue cancelAllOperations];
    //[networkQueue setDownloadProgressDelegate:progressView];
    [networkQueue setRequestDidFinishSelector:@selector(requestDone:)];
    [networkQueue setDelegate:self];
    self.data = [[NSMutableArray alloc] initWithCapacity:10];
    Rails_RankrAppDelegate* delegate = (Rails_RankrAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;    
  }
  return self;
}

-(void)syncFavorites:(UITabBarItem*)tabBarItemToUpdate {
  self.favoritesTabBarItem = tabBarItemToUpdate;
  NSError* error;
  if([[self fetchedResultsController] performFetch:&error]) {
    NSLog(@"got results from core data");
    [self grabCodersInTheBackground];
  }
  else {
    NSLog(@"somefink went wrong Horace!");
  }
  
}

-(BOOL)isFavorite:(NSString*)coderId {
  BOOL found = NO;
  for (CoreCoder* coder in [[self fetchedResultsController] fetchedObjects]) {
    if([[coder coder_id] isEqualToString:coderId]){
      found = YES;
      break;
    }
  }
  return found;
}

-(CoreCoder*)getFavorite:(NSString*)coderId {
  CoreCoder* found;
  for (CoreCoder* coder in [[self fetchedResultsController] fetchedObjects]) {
    if([[coder coder_id] isEqualToString:coderId]){
      found = coder;
      break;
    }
  }
  return found; 
}

#pragma mark -
#pragma mark ASIHTTPRequestJSON methods

- (void)grabCodersInTheBackground {
	ASIHTTPRequestJSON *request;
  NSLog(@"SYNC MANAGER: hitting: %@coders.json",HOST_SERVER);
  NSArray* existingFavorites = [[self fetchedResultsController] fetchedObjects];
  if(existingFavorites) {
    NSMutableArray* localCoders = [[NSMutableArray alloc] initWithCapacity:10];
    for (CoreCoder* coder in existingFavorites) {
      [localCoders addObject:coder.coder_id];
    }
    
    if ([localCoders count] > 0) {
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
}



- (void)requestDone:(ASIHTTPRequestJSON *)request
{
  [self.data addObjectsFromArray:[request getCoderCollection]];
  NSLog(@"SYNC MANAGER: data objects from server we have %d",[self.data count]);
  
  for (Coder* coder in self.data) {
    for (CoreCoder* coreCoder in [[self fetchedResultsController] fetchedObjects]) {
      if([coreCoder.coder_id isEqualToString:coder.coderId]) {
        NSLog(@"***********updated date: %@",coder.updatedAt);
        NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];//%a, %d %b %Y %H:%M:%S %Z"];
        NSDate* serverDate = [dateFormatter dateFromString:coder.updatedAt];
        if([coreCoder.updatedAt compare:serverDate] == NSOrderedAscending) {
          favsChanged += 1;
          coreCoder.updatedAt = serverDate;
          coreCoder.railsRankPoints = coder.fullRank;
          coreCoder.railsRank = coder.railsrank;
          coreCoder.imagePath = coder.imagePath;
          coreCoder.company = coder.companyName;
          coreCoder.city = coder.city;
          coreCoder.wwrProfileUrl = coder.wwrProfileUrl;
          coreCoder.availability = [[NSNumber alloc] initWithBool:coder.available];
          if([coder.githubUrl isMemberOfClass:[NSString class]]) {
            coreCoder.githubUrl = coder.githubUrl;            
          }
          else {
            coreCoder.githubUrl = [NSString string];
          }
          coreCoder.githubWatchers = coder.githubWatchers;
          coreCoder.hasUpdates = [[NSNumber alloc] initWithBool:YES];
          
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

  if(favsChanged > 0) {
    self.favoritesTabBarItem.badgeValue = [NSString stringWithFormat:@"%d",favsChanged];    
  }
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

-(void)resetBadges {
  self.favoritesTabBarItem.badgeValue = nil;
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
