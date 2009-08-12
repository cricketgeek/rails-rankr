//
//  Coder.h
//  RailsRank Viewer
//
//  Created by Mark Jones on 2/6/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//


@interface Coder : NSObject {
	NSString	* coderId;
	NSString	* fullName;
  NSString  * wholeName;
	NSString	* city;
	NSString	* rank;
	NSString	* fullRank;
  NSString  * railsrank;
	NSString	* companyName;
	NSString	* firstName;
	NSString	* lastName;
	NSString	* githubWatchers;
  NSString  * imagePath;
  NSString  * website;
  NSString  * wwrProfileUrl;
  NSString  * githubUrl;
  NSString    * updatedAt;
  BOOL available;
	
}

@property (nonatomic, retain) NSString *wwrProfileUrl;
@property (nonatomic, retain) NSString *githubUrl;
@property (nonatomic , retain) NSString	* coderId;
@property (nonatomic , retain) NSString	* fullName;
@property (nonatomic, retain) NSString  * wholeName;
@property (nonatomic , retain) NSString	* firstName;
@property (nonatomic , retain) NSString	* lastName;
@property (nonatomic , retain) NSString	* city;
@property (nonatomic , retain) NSString * companyName;
@property (nonatomic , retain) NSString * fullRank;
@property (nonatomic , retain) NSString * rank;
@property (nonatomic , retain) NSString * railsrank;
@property (nonatomic , retain) NSString * githubWatchers;
@property (nonatomic , retain) NSString * imagePath;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, assign) BOOL available;
@property (nonatomic, retain) NSString *updatedAt;

-(NSString*)availabilityDescription;
-(BOOL)hasWWRUrl;
-(BOOL)hasWebSite;
-(NSString*)wwrRecommendUrl;

@end
