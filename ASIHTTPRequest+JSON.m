//
//  ASIHTTPRequest+JSON.m
//  GeoTest
//
//  Created by Christopher Burnett on 7/2/09.
//  Copyright 2009 digital scientists, llc. All rights reserved.
//

#import "ASIHTTPRequest+JSON.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "CJSONDeserializer.h"
#import "Coder.h"
#import "Company.h"
#import "City.h"
#import "Location.h"

@implementation ASIHTTPRequestJSON

@synthesize responseJSON, responseCollection;

- (void)dealloc {
	[super dealloc];
}

-(NSMutableArray*)getCoderCollection {
	responseCollection	= [[NSMutableArray alloc] init];
  NSError* errorForJSON;
  NSMutableDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:[self responseData] error:&errorForJSON];
  //NSLog(@"allkeys count: %d", [[dict allKeys] count]);
  NSLog(@"what we got JSON-wise: %@",[self responseString]);
  @try {
    for (NSDictionary* object in [dict objectForKey:[[dict allKeys] objectAtIndex:0]]) {
      NSDictionary* coderDict = (NSDictionary*)[object objectForKey:@"coder"];
      Coder* new_coder = [[Coder alloc] initWithDictionary:coderDict];
      //NSLog(@"coder is %@",new_coder.fullName);
      [responseCollection addObject:new_coder];
      [new_coder release];
    }    
  }
  @catch (NSException * e) {
    NSLog(@"no dict retrieved in that call");
  }

	return responseCollection;
}

-(NSMutableArray*)getLocationCollection {
  responseCollection	= [[NSMutableArray alloc] init];
  NSError* errorForJSON;
  NSMutableDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:[self responseData] error:&errorForJSON];

  for (NSDictionary* object in [dict objectForKey:[[dict allKeys] objectAtIndex:0]]) {
    NSDictionary* locationDict = (NSDictionary*)[object objectForKey:@"location"];
    [responseCollection addObject:locationDict];
  }
  
  
	return responseCollection;
  
  
}


-(NSMutableArray*)getCompanyCollection {
	responseCollection	= [[NSMutableArray alloc] init];
  NSError* errorForJSON;
  NSMutableDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:[self responseData] error:&errorForJSON];
  //NSLog(@"allkeys count: %d", [[dict allKeys] count]);
  for (NSDictionary* object in [dict objectForKey:[[dict allKeys] objectAtIndex:0]]) {
    NSDictionary* coderDict = (NSDictionary*)[object objectForKey:@"coder"];
    Company* new_coder = [[Company alloc] initWithDictionary:coderDict];
    //NSLog(@"company is %@",new_coder.name);
    [responseCollection addObject:new_coder];
    [new_coder release];
  }
	return responseCollection;
}

-(NSMutableArray*)getCityCollection {
	responseCollection	= [[NSMutableArray alloc] init];
  NSError* errorForJSON;
  NSMutableDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:[self responseData] error:&errorForJSON];
  //NSLog(@"allkeys count: %d", [[dict allKeys] count]);
  for (NSDictionary* object in [dict objectForKey:[[dict allKeys] objectAtIndex:0]]) {
    NSDictionary* coderDict = (NSDictionary*)[object objectForKey:@"coder"];
    City* new_city = [[City alloc] initWithDictionary:coderDict];
    //NSLog(@"city is %@",new_city.name);
    [responseCollection addObject:new_city];
    [new_city release];
  }
	return responseCollection;
}

@end
