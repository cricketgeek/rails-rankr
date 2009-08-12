// 
//  CoreCoder.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/12/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "CoreCoder.h"


@implementation CoreCoder 

@dynamic lat;
@dynamic firstName;
@dynamic fullName;
@dynamic githubUrl;
@dynamic email;
@dynamic railsRankPoints;
@dynamic company;
@dynamic lon;
@dynamic webSite;
@dynamic railsRank;
@dynamic imagePath;
@dynamic wwrRank;
@dynamic city;
@dynamic updatedAt;
@dynamic githubWatchers;
@dynamic coder_id;
@dynamic twitterAccount;
@dynamic wwrProfileUrl;
@dynamic availability;
@dynamic lastName;

-(NSString*)formattedRankPoints {
  NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
  [nf setNumberStyle:NSNumberFormatterBehavior10_4];
  return [nf stringFromNumber:self.railsRankPoints];
  
}

@end
