//
//  CoderModelsConverter.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/12/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "CoderModelsConverter.h"

@implementation CoderModelsConverter

+(void)coderFromCoreCoder:(Coder*)coder andCoreCoder:(CoreCoder*)coreCoder{
  coder.wholeName = coreCoder.fullName;
  coder.railsrank = coreCoder.railsRank;
  coder.fullRank = coreCoder.railsRankPoints;
  coder.coderId = coreCoder.coder_id;
  coder.formattedFullRank = [coreCoder formattedRankPoints];
  coder.rank = coreCoder.wwrRank;
  coder.city = coreCoder.city;
  coder.wwrProfileUrl = coreCoder.wwrProfileUrl;
  coder.companyName = coreCoder.company;
  coder.githubUrl = coreCoder.githubUrl;
  coder.githubWatchers = coreCoder.githubWatchers;
  coder.imagePath = coreCoder.imagePath;
  if(coreCoder.availability) {
    coder.available = [coreCoder.availability boolValue];    
  }
  coder.firstName = coreCoder.firstName;
  coder.lastName = coreCoder.lastName;
  coder.website = coreCoder.webSite;
  NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
  [df setDateFormat:@"yyyy-MM-dd HH:MM:SS z"];
  coder.updatedAt = [df stringFromDate:coreCoder.updatedAt];
}

+(void)coreCoderFromCoder:(CoreCoder*)coreCoder andCoder:(Coder*)coder{
  NSLog(@"Coder converting is named %@",coder.wholeName);
  coreCoder.fullName = coder.wholeName;
  coreCoder.coder_id = coder.coderId;
  if([coder.githubUrl isMemberOfClass:[NSString class]]){
    coreCoder.githubUrl = coder.githubUrl;    
  }
  coreCoder.githubWatchers = coder.githubWatchers;
  coreCoder.railsRank = coder.railsrank;
  coreCoder.city = coder.city;
  coreCoder.railsRankPoints = coder.fullRank;
  coreCoder.wwrRank = coder.rank;
  coreCoder.firstName = coder.firstName;
  coreCoder.lastName = coder.lastName;
  if([coder hasWebSite]) {
    coreCoder.webSite = coder.website;    
  }
  if([coder.companyName isMemberOfClass:[NSString class]]) {
    coreCoder.company = coder.companyName;    
  }

  coreCoder.imagePath = coder.imagePath;
  coreCoder.updatedAt = [NSDate date];
  if(coder.available){
    coreCoder.availability = [NSNumber numberWithBool:coder.available];    
  }
  coreCoder.wwrProfileUrl = coder.wwrProfileUrl;
}

@end
