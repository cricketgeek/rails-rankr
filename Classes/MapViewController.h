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


@class ASINetworkQueue;
@class Rails_RankrAppDelegate;

@interface MapViewController : BaseResultsViewController <MKMapViewDelegate, UIAlertViewDelegate> {
  MKMapView *_mapView;
  NSMutableArray* locations;
  ASINetworkQueue *networkQueue;
  UIApplication* app;
  Rails_RankrAppDelegate* delegate;
}
@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) NSMutableArray* locations;

-(IBAction)mapLocation;
-(void)getLocationsInBackground;
-(void)locationsUpdated:(NSNotification*)notification;

@end
