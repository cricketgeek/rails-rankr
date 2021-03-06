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
formattedFullRank, rank, railsrank, githubWatchers, imagePath, website, available, wwrProfileUrl, githubUrl, updatedAt;

- (NSString *)fullName {
  if(self.wholeName != nil) {
    return [NSString stringWithFormat:@"%@",self.wholeName];
  }
  else {
    return [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];    
  }
}

- (id)initWithDictionary:(NSDictionary*)dict {
  if((self = [super init])) {
    @try {
      self.coderId = [(NSNumber*)[dict objectForKey:@"id"] stringValue];
      if([dict objectForKey:@"scraperUpdateDate"] != nil) {
//        NSDateFormatter* df = [[NSDateFormatter alloc] init];
//        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
//        self.updatedAt = [df dateFromString:[dict objectForKey:@"scraperUpdateDate"]];
        self.updatedAt = [dict objectForKey:@"scraperUpdateDate"];
      }
      else {
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        self.updatedAt = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
      }
      self.wwrProfileUrl = [dict objectForKey:@"profile_url"];
      self.githubUrl = [dict objectForKey:@"github_url"];
      self.firstName = [dict objectForKey:@"first_name"];
      self.wholeName = [dict objectForKey:@"whole_name"];
      NSLog(@"coder wholeName: %@",self.wholeName);
      self.lastName = [dict objectForKey:@"last_name"];
      NSNumber* railsrankNumber = [dict objectForKey:@"railsrank"];
      self.railsrank = [railsrankNumber integerValue] < MAX_RANK ? [railsrankNumber stringValue] : @"Nil";
      self.rank = [(NSNumber*)[dict objectForKey:@"rank"] stringValue];
      self.imagePath = [dict objectForKey:@"image_path"];
      NSNumberFormatter* nf = [[[NSNumberFormatter alloc] init] autorelease];
      [nf setNumberStyle:NSNumberFormatterBehavior10_4];
      self.fullRank = (NSNumber*)[dict objectForKey:@"full_rank"];
      self.formattedFullRank = [nf stringFromNumber:self.fullRank];
      self.city = [dict objectForKey:@"city"];
      self.companyName = [dict objectForKey:@"company_name"];
      self.githubWatchers = [(NSNumber*)[dict objectForKey:@"github_watchers"] stringValue];
      self.website = [dict objectForKey:@"website"];
      //NSLog(@"is available? %@",[dict objectForKey:@"is_available_for_hire"]);
      if([[dict valueForKey:@"is_available_for_hire"] isMemberOfClass:[NSNumber class]] ) {
        self.available = [(NSNumber*)[dict valueForKey:@"is_available_for_hire"] boolValue];      
      }
      
    }
    @catch (NSException * e) {
      NSLog(@"what happened? %@",[e description]);
    }

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

- (BOOL)isEqual:(id)anObject {
  if([anObject isMemberOfClass:[Coder class]]) {
    Coder* otherCoder = (Coder*)anObject;
    if(self.coderId == otherCoder.coderId) {
      return YES;      
    }
    else {
      return NO;      
    }
  }
  else {
    
    return NO;
  }  
}

@end
