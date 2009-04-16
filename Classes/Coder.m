//
//  Coder.m
//  RailsRank Viewer
//
//  Created by Mark Jones on 2/6/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "Coder.h"
#import "ObjectiveResource.h"


@implementation Coder
@synthesize coderId, fullName, firstName, lastName, city, companyName, fullRank, 
            rank, railsRank, githubWatchers, imagePath;

- (NSString *)fullName {
	return [NSString stringWithFormat:@"%@ %@",firstName,lastName];
}

// handle pluralization 
+ (NSString *)getRemoteCollectionName {
	return @"coders";
}

@end
