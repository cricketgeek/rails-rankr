//
//  Rails_RankrAppDelegate.h
//  Rails Rankr
//
//  Created by Mark Jones on 4/4/09.
//  Copyright Geordie Enterprises LLC 2009. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CoderFavoritesViewController.h"
#import "CoderResultsViewController.h"
#import "CompanyResultsViewController.h"
#import "CityResultsViewController.h"
#import "Constants.h"
#import "SyncManager.h"
#import "Reachability.h"

@interface Rails_RankrAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
  UIWindow *window;
  UITabBarController *tabBarController;
  UITabBarItem* favoritesTabBarItem;
  CoderFavoritesViewController* coderFavoritesViewController;
  CoderResultsViewController* coderResultsViewController;
  CompanyResultsViewController* companyResultsViewController;
  CityResultsViewController* cityResultsViewController;
  NSManagedObjectModel *managedObjectModel;
  NSManagedObjectContext *managedObjectContext;	    
  NSPersistentStoreCoordinator *persistentStoreCoordinator;  
  SyncManager* syncManager;
  Reachability* hostReach;
}

@property (nonatomic, retain) SyncManager *syncManager;
@property (nonatomic, retain) IBOutlet CoderFavoritesViewController *coderFavoritesViewController;
@property (nonatomic, retain) IBOutlet CoderResultsViewController *coderResultsViewController;
@property (nonatomic, retain) IBOutlet CompanyResultsViewController *companyResultsViewController;
@property (nonatomic, retain) IBOutlet CityResultsViewController *cityResultsViewController;
@property (nonatomic, retain) IBOutlet UITabBarItem *favoritesTabBarItem;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) Reachability *hostReach;

-(BOOL)haveNetworkAccess;
-(NSString*)udid;
-(NSString*)getBaseUrl:(NSString*)entityName;

@end
