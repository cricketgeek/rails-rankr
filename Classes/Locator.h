//
//  Locator.h
//  Rails Rankr
//
//  Created by Mark Jones on 7/23/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ASINetworkQueue.h"
#import "Location.h"

@class Rails_RankrAppDelegate;

@interface Locator : NSObject <CLLocationManagerDelegate, MKReverseGeocoderDelegate> {
  CLLocationManager* locationManager;
  ASINetworkQueue* networkQueue;
  Rails_RankrAppDelegate* appDelegate;
  NSString* nameForLocation;
}
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) NSString *nameForLocation;
- (void)start;
- (void)startWithName:(NSString*)name;
- (void)saveLocation:(CLLocation*)location;
- (void)saveLocationInCoreData;
- (void)saveLocationInTheBackground:(Location*)location;
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error;
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark;

@end
