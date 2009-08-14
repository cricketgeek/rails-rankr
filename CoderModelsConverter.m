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
  coder.fullName = coreCoder.fullName;
  coder.railsrank = coreCoder.railsRank;
  coder.fullRank = coreCoder.railsRankPoints;
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
  NSDateFormatter* df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"“yyyy-MM-dd HH:MM:SS z"];
  coder.updatedAt = [df stringFromDate:coreCoder.updatedAt];
}

+(void)coreCoderFromCoder:(CoreCoder*)coreCoder andCoder:(Coder*)coder{
  coreCoder.fullName = coder.fullName;
  coreCoder.coder_id = coder.coderId;
  coreCoder.githubUrl = coder.githubUrl;
  coreCoder.githubWatchers = coder.githubWatchers;
  coreCoder.railsRank = coder.railsrank;
  coreCoder.city = coder.city;
  coreCoder.railsRankPoints = coder.fullRank;
  coreCoder.wwrRank = coder.rank;
  coreCoder.firstName = coder.firstName;
  coreCoder.lastName = coder.lastName;
  coreCoder.webSite = coder.website;
  coreCoder.company = coder.companyName;
  coreCoder.imagePath = coder.imagePath;
  coreCoder.updatedAt = [NSDate date];
  if(coder.available){
    coreCoder.availability = [NSNumber numberWithBool:coder.available];    
  }
  coreCoder.wwrProfileUrl = coder.wwrProfileUrl;
}

@end
