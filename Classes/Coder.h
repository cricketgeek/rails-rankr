//
//  Coder.h
//  RailsRank Viewer
//
//  Created by Mark Jones on 2/6/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "ObjectiveResource.h"

@interface Coder : NSObject {
	NSString	* coderId;
	NSString	* fullName;
	NSString	* city;
	NSString	* rank;
	NSString	* fullRank;
  NSString  * railsRank;
	NSString	* companyName;
	NSString	* firstName;
	NSString	* lastName;
	NSString	* githubWatchers;
  NSString  * imagePath;
	
}

@property (nonatomic , retain) NSString	* coderId;
@property (nonatomic , retain) NSString	* fullName;
@property (nonatomic , retain) NSString	* firstName;
@property (nonatomic , retain) NSString	* lastName;
@property (nonatomic , retain) NSString	* city;
@property (nonatomic , retain) NSString * companyName;
@property (nonatomic , retain) NSString * fullRank;
@property (nonatomic , retain) NSString * rank;
@property (nonatomic , retain) NSString * railsRank;
@property (nonatomic , retain) NSString * githubWatchers;
@property (nonatomic , retain) NSString * imagePath;

@end
