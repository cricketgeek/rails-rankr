//
//  City.m
//  Rails Rankr
//
//  Created by Mark Jones on 4/4/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "Company.h"


@implementation Company
@synthesize name, points, rank, githubWatchers, numberOfCoders; //companyId;

- (id)initWithDictionary:(NSDictionary*)dict {
  if((self = [super init])) {
    self.rank = [(NSNumber*)[dict objectForKey:@"railsrank"] stringValue];
    //self.imagePath = [dict objectForKey:@"image_path"];
    self.points = [dict objectForKey:@"total"];
    self.name = [dict objectForKey:@"company_name"];
    //self.githubWatchers = [(NSNumber*)[dict objectForKey:@"github_watchers"] stringValue];
    self.numberOfCoders = [dict objectForKey:@"count"];
  }
  return self;
  
}

@end
