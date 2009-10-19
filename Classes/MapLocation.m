//
//  MapLocation.m
//  NannyFeedMe_ver1
//
//  Created by Mark Jones on 7/23/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "MapLocation.h"
#import <CoreLocation/CoreLocation.h>

@implementation MapLocation

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (id)initWithLocation:(Location *)plocation {
  self = [super init];
	if(nil != self) {
    if (plocation.name != nil) {
      self.title = plocation.name;
    }
    else {
      self.title = [NSString stringWithFormat:@"%@",[plocation street]];
    }

    self.subtitle = [NSString stringWithFormat:@"Street: testing"];
    CLLocation* core_location = [[CLLocation alloc] initWithLatitude:[plocation.lat floatValue]
                                                           longitude:[plocation.lon floatValue]];    
    self.coordinate = [core_location coordinate];
  }
  return self;
}

- (void) dealloc
{
  [_title release];
  [_subtitle release];
	[super dealloc];
}


@end
