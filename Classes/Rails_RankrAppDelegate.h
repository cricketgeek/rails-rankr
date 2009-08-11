//
//  Rails_RankrAppDelegate.h
//  Rails Rankr
//
//  Created by Mark Jones on 4/4/09.
//  Copyright Geordie Enterprises LLC 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoderDetailViewController.h"
#import "CoderFavoritesViewController.h"
#import "Constants.h"

@interface Rails_RankrAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
  
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;  
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
