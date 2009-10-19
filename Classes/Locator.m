//
//  Locator.m
//  Rails Rankr
//
//  Created by Mark Jones on 7/23/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//
#import "Locator.h"
#import "ASIHTTPRequest+JSON.h"
#import "ASIFormDataRequest.h"
#import "CJSONSerializer.h"
#import "Rails_RankrAppDelegate.h"
#import "Constants.h"

@implementation Locator

@synthesize locationManager;
@synthesize nameForLocation;

-(id)init{
  if (self = [super init]) {
    appDelegate = (Rails_RankrAppDelegate*)[[UIApplication sharedApplication] delegate];
    networkQueue = [[ASINetworkQueue alloc] init];
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.distanceFilter = 50.0f;
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  }
  return self;
}

-(void)start {
  
  [self.locationManager startUpdatingLocation];
  
}

- (void)startWithName:(NSString*)name {
  
  self.nameForLocation = name;
  [self start];
  
}

-(void)saveLocationInCoreData {
  
    NSError *error;
    if (![[appDelegate managedObjectContext] save:&error]) {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      //TODO alert message
    }
}

#pragma mark -
#pragma mark ASIHTTPRequestJSON methods

- (void)saveLocationInTheBackground:(Location*)location
{
  // [self.view addSubview:spinner];
  //  [spinner startAnimating];
  NSString* baseUrl = [appDelegate getBaseUrl:@"locations"];   
  ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL:[NSURL 
                                                                 URLWithString:baseUrl]]; 
  
  [request addRequestHeader: @"Content-Type" value: @"application/json"];
  [request setDelegate:self];
  [request setDidFailSelector:@selector(requestWentWrong)];
  [request setDidFinishSelector:@selector(requestDone)];
  
  NSMutableDictionary* locationDict = [[NSMutableDictionary alloc] init];
  [locationDict setObject:[location.lat stringValue] forKey:@"lat"];
  [locationDict setObject:[location.lon stringValue] forKey:@"lon"];
  [locationDict setObject:location.postalCode forKey:@"zip"];
  [locationDict setObject:location.city forKey:@"city"];
  [locationDict setObject:location.street forKey:@"street"];
  if (location.name != nil) {
    [locationDict setObject:location.name forKey:@"name"];
  }
  
  
  [locationDict setObject:[appDelegate udid] forKey:@"udid"];
  
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
  [dict setObject:locationDict forKey:@"location"];
  
  NSString* jsonNestedString = [[CJSONSerializer serializer] serializeDictionary:dict];
  
  // JSON via TouchJSON 
  // Convert Dictionary to JSON Data 
  NSData* jsonData = [jsonNestedString dataUsingEncoding:NSUTF8StringEncoding]; 
  
  request.delegate = self; 
  request.postBody = [[jsonData mutableCopy] autorelease]; 
  
  [networkQueue setRequestDidFinishSelector:@selector(requestDone:)];
  [networkQueue setDelegate:self];
	[request setTimeOutSeconds:20];
  [networkQueue addOperation:request];
  [networkQueue go];
}

- (void)requestDone:(ASIFormDataRequest *)request
{
  NSLog(@"response was: %@",[request responseString]);
  //[self close:YES];
  [[NSNotificationCenter defaultCenter] postNotificationName:LOCATIONS_UPDATED object:nil];
}

- (void)requestWentWrong:(ASIFormDataRequest *)request
{
  NSError *error = [request error];
  NSLog(@"error occurred %@",[error localizedDescription]);
  //gettingDataNow = NO;
  //app.networkActivityIndicatorVisible = NO;
  //[self close:NO];
}



//- (CLLocationDistance)totalDistanceTraveled {
//  CGFloat totalDistanceTraveled = 0.0f;
//  CLLocation *oldLocation = nil;
//  for(CLLocation *location in self.locations) {
//    if(nil == oldLocation) {
//      oldLocation = location;
//      continue;
//    }
//    totalDistanceTraveled += fabs([location getDistanceFrom:oldLocation]);
//    oldLocation = location;
//  }
//  return totalDistanceTraveled;
//}

//- (NSTimeInterval)timeDelta {
//  if([self.locations count] > 0) {
//    NSDate *first = [(CLLocation *)[self.locations objectAtIndex:0] timestamp];
//    NSDate *last = [(CLLocation *)[self.locations lastObject] timestamp];
//    return [last timeIntervalSince1970] - [first timeIntervalSince1970];    
//  }
//  else {
//    return 0;
//  }
//}

- (void)saveLocation:(CLLocation*)location {
  //  CLLocationDistance distance = [self totalDistanceTraveled];
  //  //totalDistance.text = [NSString stringWithFormat:@"%5.3f" , distance];
  //  NSTimeInterval time = [self timeDelta];
  // don't want to divide by zero
  //  if(time == 0.0f) {
  //    averageSpeed.text = @"0.000" ;
  //  } else {
  //    averageSpeed.text = [NSString stringWithFormat:@"%5.3f" , distance / time];
  //  }
  //  NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
  //  [inputFormatter setDateFormat:@"HH:mm:ss.SSSS" ];
  // CLLocation* lastLocation = location;
  // NSDate *date = [lastLocation timestamp];
  //lastUpdate.text = [inputFormatter stringFromDate:date];
  
  MKReverseGeocoder* revGeoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:location.coordinate];
  revGeoCoder.delegate = self;
  [revGeoCoder start];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  
  if(newLocation.horizontalAccuracy > 0.0f) {
    [self.locationManager stopUpdatingLocation];
    [self saveLocation:newLocation];
  }
  
}

#pragma mark -
#pragma mark MKReverseGeocoderDelegate methods

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
  
  NSLog(@"county: %@",[placemark country]);
  NSLog(@"postalCode: %@",[placemark postalCode]);
  NSLog(@"thoroughfare: %@",[placemark thoroughfare]);
  NSLog(@"locality: %@",[placemark locality]);
  NSLog(@"description %@",[placemark description]);
  
  NSEntityDescription *entity = [[[appDelegate managedObjectModel] entitiesByName] objectForKey:@"Location"];
  
  Location* location = [[Location alloc] initWithEntity:entity insertIntoManagedObjectContext:[appDelegate managedObjectContext]];
                        
  location.lat = [[NSNumber alloc] initWithFloat:[placemark coordinate].latitude];
  location.lon = [[NSNumber alloc] initWithFloat:[placemark coordinate].longitude];
  location.country = [placemark country];
  location.postalCode = [placemark postalCode];
  location.street = [placemark thoroughfare];
  location.city = [placemark locality];
  if (self.nameForLocation != nil) {
    location.name = self.nameForLocation;
  }
  
  [self saveLocationInCoreData];
  [self saveLocationInTheBackground:location];
  
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
  NSLog(@"Error: %@",[error description]);
  
}

- (void)dealloc {
  [self.locationManager release];
  [super dealloc];
  
}

@end
