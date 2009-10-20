//
//  MapViewController.h
//  Rails Rankr
//
//  Created by Mark Jones on 10/8/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseResultsViewController.h"
#import "MapPointsTableViewController.h"

@class ASINetworkQueue;
@class Rails_RankrAppDelegate;

@interface MapViewController : BaseResultsViewController <MKMapViewDelegate, UIAlertViewDelegate> {
  MKMapView *mapView;
  NSMutableArray* locations;
  ASINetworkQueue *networkQueue;
  UIApplication* app;
  Rails_RankrAppDelegate* delegate;
  MapPointsTableViewController* mapPointsTableViewController;
  
}
@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) NSMutableArray* locations;
@property (nonatomic, retain) IBOutlet MapPointsTableViewController *mapPointsTableViewController;

-(IBAction)mapLocation;
-(void)getLocationsInBackground;
-(void)locationsUpdated:(NSNotification*)notification;
-(void)toggleToEditView;

@end
