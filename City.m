//
//  City.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/10/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "City.h"


@implementation City

@synthesize name, points, rank, numberOfCoders;

- (id)initWithDictionary:(NSDictionary*)dict {
  if((self = [super init])) {
    self.points = [dict objectForKey:@"total"];
    self.name = [dict objectForKey:@"city"];
    self.numberOfCoders = [dict objectForKey:@"count"];
    self.rank = [(NSNumber*)[dict objectForKey:@"railsrank"] stringValue];
  }
  return self;
  
}

@end
