//
//  Rails_RankrAppDelegate.m
//  Rails Rankr
//
//  Created by Mark Jones on 4/4/09.
//

#import "Rails_RankrAppDelegate.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import "FlurryAPI.h"

#import <CoreFoundation/CoreFoundation.h>
#define kShouldPrintReachabilityFlags 1

@implementation Rails_RankrAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize coderFavoritesViewController;
@synthesize coderResultsViewController;
@synthesize companyResultsViewController;
@synthesize cityResultsViewController;
@synthesize favoritesTabBarItem;
@synthesize syncManager;
@synthesize hostReach;

-(BOOL)haveNetworkAccess {
  return ([hostReach currentReachabilityStatus]  != NotReachable);
}

-(NSString*)udid {
  NSString* UDID = [NSString stringWithFormat:@"%@",[UIDevice currentDevice].uniqueIdentifier];
  if (UDID != nil) {
    return UDID;
  }
  else {
    NSLog(@"unable to find udid for phone");
    return [NSString string];
  }

}

-(NSString*)getBaseUrl:(NSString*)entityName {
  
  NSString* urlBase = [NSString stringWithFormat:@"%@%@.json",HOST_SERVER,entityName];
  return urlBase;
  
}

void uncaughtExceptionHandler(NSException *exception) {
  [FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
} 

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];

  hostReach = [[Reachability reachabilityWithHostName: HOST_SERVER_CONNECT] retain];
	[hostReach startNotifer];
  NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
  
  [FlurryAPI startSessionWithLocationServices:FLURRY_API_KEY];
  [FlurryAPI setSessionReportsOnCloseEnabled:YES];
  // Add the tab bar controller's current view as a subview of the window
  [window addSubview:tabBarController.view];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
  NSError *error;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle error.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
    } 
  }
}


//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
  NetworkStatus netStatus = [curReach currentReachabilityStatus];

  if(netStatus == NotReachable) {
    UIAlertView* errorView = [[UIAlertView alloc] 
                              initWithTitle: @"Network Error" 
                              message: @"Network is down at the moment. Stiff upper lip mate, favorites tab will work until you get back to civilization."
                              delegate: self 
                              cancelButtonTitle: @"Close" otherButtonTitles: nil];
    [errorView show];
    [errorView autorelease];
    [self.coderResultsViewController showNetworkUnavailableView];
    [self.companyResultsViewController showNetworkUnavailableView];
    [self.cityResultsViewController showNetworkUnavailableView];
  }
  else {
    [self.coderResultsViewController hideNetworkUnavailableView];
    [self.companyResultsViewController hideNetworkUnavailableView];
    [self.cityResultsViewController hideNetworkUnavailableView];
    [self.coderResultsViewController grabCodersInTheBackground];
    self.syncManager = [[SyncManager alloc] init];
    [self.syncManager syncFavorites:favoritesTabBarItem];
  }

}


 // Optional UITabBarControllerDelegate method
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
   //NSLog(@"in didSelectViewController %@", [viewController class]);
   //UIViewController* view = [(UINavigationController*)viewController v
   NSLog(@"%@ tab",[[tabBarController selectedViewController] class]);
   
 }
 

/*
 // Optional UITabBarControllerDelegate method
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
 }
 */

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
  if (managedObjectContext != nil) {
    return managedObjectContext;
  }
	
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator: coordinator];
  }
  return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
  if (managedObjectModel != nil) {
    return managedObjectModel;
  }
  managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
  return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
  if (persistentStoreCoordinator != nil) {
    return persistentStoreCoordinator;
  }
	
  NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: [NSString stringWithFormat:@"CoreCoders_%@.sqlite",APP_VERSION]]];
	
	NSError *error;
  persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
  if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
    // Handle error
  }    
	
  return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
  return basePath;
}


- (void)dealloc {
  [hostReach release];
  [managedObjectContext release];
  [managedObjectModel release];
  [persistentStoreCoordinator release];  
  [tabBarController release];
  [window release];
  [super dealloc];
}

@end

