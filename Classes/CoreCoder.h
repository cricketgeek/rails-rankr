//
//  CoreCoder.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/11/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface CoreCoder :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * githubUrl;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * railsRankPoints;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSString * webSite;
@property (nonatomic, retain) NSString * railsRank;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * wwrRank;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * githubWatchers;
@property (nonatomic, retain) NSString * coder_id;
@property (nonatomic, retain) NSString * twitterAccount;
@property (nonatomic, retain) NSString * wwrProfileUrl;
@property (nonatomic, retain) NSNumber * availability;
@property (nonatomic, retain) NSString * lastName;

@end



