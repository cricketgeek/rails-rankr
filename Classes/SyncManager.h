//
//  SyncManager.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/12/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest+JSON.h"
#import "ASINetworkQueue.h"


@interface SyncManager : NSObject <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
  NSManagedObjectContext *addingManagedObjectContext;
  NSMutableArray* data;
  ASINetworkQueue *networkQueue;
  UIApplication *app;
  BOOL gettingDataNow;  
}

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;

-(void)syncFavorites:(UITabBarItem*)tabBarItemToUpdate;

@end
