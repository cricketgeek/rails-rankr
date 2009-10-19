//
//  MapLocation.h
//  NannyFeedMe_ver1
//
//  Created by Mark Jones on 7/23/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//
#import "Location.h"
#import <MapKit/MapKit.h>

@interface MapLocation : NSObject <MKAnnotation> {
	NSString *_title;
	NSString *_subtitle;
  CLLocationCoordinate2D _coordinate;
}

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithLocation:(Location *)plocation;

@end
