//
//  MapViewController.m
//  Rails Rankr
//
//  Created by Mark Jones on 10/8/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "MapViewController.h"
#import "Locator.h"
#import "MapLocation.h"
#import "Rails_RankrAppDelegate.h"
#import "ASIHTTPRequest+JSON.h"
#import "ASINetworkQueue.h"
#import "Constants.h"


@interface UIAlertView (Extended)
- (UITextField*)addTextFieldWithValue:(NSString*)value label:(NSString*)label;
- (UITextField*)textFieldAtIndex:(NSUInteger)index;
- (NSUInteger)textFieldCount;
- (UITextField*)textField;
@end


@implementation MapViewController

@synthesize mapView, locations;

-(IBAction)mapLocation {
  
  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Location" 
                                                  message:@"Enter a name for this location" 
                                                 delegate:self 
                                        cancelButtonTitle:@"Cancel" 
                                        otherButtonTitles:@"Save", nil];
  
  [alert addTextFieldWithValue:@"" label:@"Enter Name"];
  
  [alert show];

}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  
  NSLog(@"button index was %d",buttonIndex);
  UITextField* textEntry = [alertView textFieldAtIndex:0];
  NSString* name = [textEntry text];
  
  Locator* locationManager = [[Locator alloc] init];
  [locationManager startWithName:name];
  
}

- (void)recenterMap {
  if ([self.locations count] > 0) {
    NSArray *coordinates = [self.mapView valueForKeyPath:@"annotations.coordinate"];
    CLLocationCoordinate2D maxCoord = {-90.0f, -180.0f};
    CLLocationCoordinate2D minCoord = {90.0f, 180.0f};
    for(NSValue *value in coordinates) {
      CLLocationCoordinate2D coord = {0.0f, 0.0f};
      [value getValue:&coord];
      if(coord.longitude > maxCoord.longitude) {
        maxCoord.longitude = coord.longitude;
      }
      if(coord.latitude > maxCoord.latitude) {
        maxCoord.latitude = coord.latitude;
      }
      if(coord.longitude < minCoord.longitude) {
        minCoord.longitude = coord.longitude;
      }
      if(coord.latitude < minCoord.latitude) {
        minCoord.latitude = coord.latitude;
      }
    }
    MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
    region.center.longitude = (minCoord.longitude + maxCoord.longitude) / 2.0;
    region.center.latitude = (minCoord.latitude + maxCoord.latitude) / 2.0;
    region.span.longitudeDelta = maxCoord.longitude - minCoord.longitude;
    region.span.latitudeDelta = maxCoord.latitude - minCoord.latitude;
    [self.mapView setRegion:region animated:YES];
  }
  
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView 
            viewForAnnotation:(id <MKAnnotation>)annotation {
  MKAnnotationView *view = nil;
  if(annotation != mapView.userLocation) {
		MapLocation *mapLoc = (MapLocation*)annotation;
		view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"coderLoc"];
		if(nil == view) {
			view = [[[MKPinAnnotationView alloc] initWithAnnotation:mapLoc
                                              reuseIdentifier:@"coderLoc"] autorelease];
		}
    [(MKPinAnnotationView *)view setPinColor:MKPinAnnotationColorRed];
		[(MKPinAnnotationView *)view setAnimatesDrop:YES];
		[view setCanShowCallout:YES];
    [view setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
  } else {
    NSLog(@"this is the user's location");
  }
  
  return view;
}

- (void)mapView:(MKMapView *)mapView 
 annotationView:(MKAnnotationView *)view 
calloutAccessoryControlTapped:(UIControl *)control {
  //EarthquakeAnnotation *eqAnn = (EarthquakeAnnotation *)[view annotation];
  //  NSURL *url = [NSURL URLWithString:eqAnn.earthquake.detailsURL];
  //  [[UIApplication sharedApplication] openURL:url];
  NSLog(@"callout tapped on map");
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
  UIBarButtonItem *saveLocationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                                                      target:self 
                                                                                      action:@selector(mapLocation)];
  
  networkQueue = [[ASINetworkQueue alloc] init];
  [networkQueue cancelAllOperations];
	[networkQueue setRequestDidFinishSelector:@selector(requestDone:)];
	[networkQueue setDelegate:self];
  self.navigationItem.rightBarButtonItem = saveLocationButton;
  app = [UIApplication sharedApplication];
  delegate = (Rails_RankrAppDelegate*)[app delegate];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationsUpdated:) name:LOCATIONS_UPDATED object:nil];
}


-(void)locationsUpdated:(NSNotification*)notification {
  
  [self getLocationsInBackground];
}

-(void)getLocationsInBackground {
  
  [self.view addSubview:spinner];
  [spinner startAnimating]; 

  Rails_RankrAppDelegate* appDelegate = (Rails_RankrAppDelegate*)[[UIApplication sharedApplication] delegate];
    
  NSString *path = [[NSString stringWithFormat:[appDelegate getBaseUrl:@"locations"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  
  ASIHTTPRequestJSON *request;
  request = [[[ASIHTTPRequestJSON alloc] initWithURL:[NSURL URLWithString:path]] autorelease]; 
  
  [networkQueue addOperation:request];
  [networkQueue go];
}

- (void)requestDone:(ASIHTTPRequestJSON *)request
{
  
  NSMutableArray* locationDicts = [request getLocationCollection];
  Location* newLocation;
  NSLog(@"%d locations",[locationDicts count]);
  for(NSDictionary* locationDict in locationDicts) {
    newLocation = (Location *)[NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:[delegate managedObjectContext]];
    [newLocation updateAttributes:locationDict];
    MapLocation* newMapLocation = [[MapLocation alloc] initWithLocation:newLocation];
    [self.locations addObject:newMapLocation];
    [self.mapView addAnnotation:newMapLocation];
    MKReverseGeocoder* revGeoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newMapLocation.coordinate];
    [revGeoCoder start];
  }
  
  NSLog(@"the map has %d annotations",[[self.mapView annotations] count]);
  [self recenterMap];
  
  gettingDataNow = NO;
  [spinner stopAnimating];
  app.networkActivityIndicatorVisible = NO;
}

- (void)requestWentWrong:(ASIHTTPRequestJSON *)request
{
  NSError *error = [request error];
  NSLog(@"error occurred %@",[error localizedDescription]);
  gettingDataNow = NO;
  [spinner stopAnimating];
  app.networkActivityIndicatorVisible = NO;
}


-(void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  
  //TODO get locations users location
  //TODO search within 20 miles of users location
  //TODO pull all appropriate locations based on this user's location
  self.locations = Nil;
  self.locations = [[NSMutableArray alloc] init];
  [self.mapView removeAnnotations:self.locations];
  [self getLocationsInBackground];
  
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [_mapView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


@end
