//
//  Coder.m
//  RailsRank Viewer
//
//  Created by Mark Jones on 2/6/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "Coder.h"

@implementation Coder
@synthesize coderId, fullName, firstName, lastName, city, companyName, fullRank, 
rank, railsrank, githubWatchers, imagePath, website, available;

- (NSString *)fullName {
	return [NSString stringWithFormat:@"%@ %@",firstName,lastName];
}

- (id)initWithDictionary:(NSDictionary*)dict {
  if((self = [super init])) {
    self.coderId = [dict objectForKey:@"id"];
    self.firstName = [dict objectForKey:@"first_name"];
    self.lastName = [dict objectForKey:@"last_name"];
    self.railsrank = [(NSNumber*)[dict objectForKey:@"railsrank"] stringValue];
    self.rank = [(NSNumber*)[dict objectForKey:@"rank"] stringValue];
    self.imagePath = [dict objectForKey:@"image_path"];
    self.fullRank = [(NSNumber*)[dict objectForKey:@"full_rank"] stringValue];
    self.city = [dict objectForKey:@"city"];
    self.companyName = [dict objectForKey:@"company_name"];
    self.githubWatchers = [(NSNumber*)[dict objectForKey:@"github_watchers"] stringValue];
    self.website = [dict objectForKey:@"website"];
    self.available = (BOOL)[dict objectForKey:@"is_available_for_hire"];
  }
  return self;
  
}

-(NSString*)availabilityDescription {
  return [[NSString alloc] initWithString:@"Available"];
}

@end
