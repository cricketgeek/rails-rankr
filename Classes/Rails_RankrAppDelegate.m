//
//  Rails_RankrAppDelegate.m
//  Rails Rankr
//
//  Created by Mark Jones on 4/4/09.
//  Copyright Geordie Enterprises LLC 2009. All rights reserved.
//

#import "Rails_RankrAppDelegate.h"
#import "ObjectiveResource.h"

@implementation Rails_RankrAppDelegate

@synthesize window;
@synthesize tabBarController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    //Configure ObjectiveResource
    [ObjectiveResourceConfig setSite:@"http://localhost:3000/"];
    // use json
    [ObjectiveResourceConfig setResponseType:JSONResponse];
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

