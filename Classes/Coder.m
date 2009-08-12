//
//  Coder.m
//  RailsRank Viewer
//
//  Created by Mark Jones on 2/6/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "Coder.h"

@implementation Coder
@synthesize coderId, fullName, wholeName, firstName, lastName, city, companyName, fullRank, 
rank, railsrank, githubWatchers, imagePath, website, available, wwrProfileUrl, githubUrl, updatedAt;

- (NSString *)fullName {
  if([self.wholeName isKindOfClass:[NSString class]]) {
    return [NSString stringWithFormat:@"%@",self.wholeName];
  }
  else {
    return [NSString stringWithFormat:@"%@ %@",firstName,lastName];    
  }
}

- (id)initWithDictionary:(NSDictionary*)dict {
  if((self = [super init])) {
    self.coderId = [(NSNumber*)[dict objectForKey:@"id"] stringValue];
    self.updatedAt = [dict objectForKey:@"updated_at"];
    self.wwrProfileUrl = [dict objectForKey:@"profile_url"];
    self.githubUrl = [dict objectForKey:@"github_url"];
    self.firstName = [dict objectForKey:@"first_name"];
    self.wholeName = [dict objectForKey:@"whole_name"];
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

-(BOOL)hasWWRUrl {
  return [self.wwrProfileUrl isKindOfClass:[NSString class]] ? YES : NO;
}

-(BOOL)hasWebSite {
  return [self.website isKindOfClass:[NSString class]] ? YES : NO;
}

-(NSString*)wwrRecommendUrl{
  
  /*http://www.workingwithrails.com/recommendation/new/person/6415-john-nunemaker
  http://www.workingwithrails.com/person/6415-john-nunemaker
  */
  
  if([self.wwrProfileUrl isKindOfClass:[NSString class]]) {
    return [self.wwrProfileUrl stringByReplacingCharactersInRange:NSMakeRange(31,8) withString:@"/recommendation/new/person/"];    
  }
  else {
    return [NSString string];
  }
}

-(NSString*)availabilityDescription {
  if(self.available) {
    return [[NSString alloc] initWithString:@"Available"];    
  }
  else {
    return [[NSString alloc] initWithString:@"Quite busy, sorry"];
  }

}

@end
