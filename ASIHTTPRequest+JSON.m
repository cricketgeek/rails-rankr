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

@implementation ASIHTTPRequestJSON

@synthesize responseJSON, responseCollection;

- (void)dealloc {
	[super dealloc];
}

-(NSMutableArray*)getCoderCollection {
	responseCollection	= [[NSMutableArray alloc] init];
  NSError* errorForJSON;
  NSMutableDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:[self responseData] error:&errorForJSON];
  NSLog(@"dict is : %@", [dict class]);
  NSLog(@"dict is : %@",dict);
  NSLog(@"allkeys count: %d", [[dict allKeys] count]);
  for (NSDictionary* object in [dict objectForKey:[[dict allKeys] objectAtIndex:0]]) {
    NSDictionary* coderDict = (NSDictionary*)[object objectForKey:@"coder"];
    Coder* new_coder = [[Coder alloc] initWithDictionary:coderDict];
    NSLog(@"coder is %@",new_coder.fullName);
    [responseCollection addObject:new_coder];
    [new_coder release];
  }
	return responseCollection;
}


-(NSMutableArray*)getCompanyCollection {
	responseCollection	= [[NSMutableArray alloc] init];
  NSError* errorForJSON;
  NSMutableDictionary *dict = [[CJSONDeserializer deserializer] deserializeAsDictionary:[self responseData] error:&errorForJSON];
  NSLog(@"dict is : %@", [dict class]);
  NSLog(@"dict is : %@",dict);
  NSLog(@"allkeys count: %d", [[dict allKeys] count]);
  for (NSDictionary* object in [dict objectForKey:[[dict allKeys] objectAtIndex:0]]) {
    NSDictionary* coderDict = (NSDictionary*)[object objectForKey:@"coder"];
    Company* new_coder = [[Company alloc] initWithDictionary:coderDict];
    NSLog(@"company is %@",new_coder.name);
    [responseCollection addObject:new_coder];
    [new_coder release];
  }
	return responseCollection;
}

@end
