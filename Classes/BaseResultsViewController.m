//
//  BaseResultsViewController.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/6/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "BaseResultsViewController.h"


@implementation BaseResultsViewController

@synthesize spinner;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

-(void)showNetworkUnavailableView {
  UIView* networkBadView = [self.view viewWithTag:(int)86];
  [self.view bringSubviewToFront:networkBadView];
}

-(void)hideNetworkUnavailableView {
  UIView* networkBadView = [self.view viewWithTag:(int)86];
  [self.view sendSubviewToBack:networkBadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [spinner setCenter:CGPointMake(160.0,240.0)]; 
  
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
  [super dealloc];
}


@end
