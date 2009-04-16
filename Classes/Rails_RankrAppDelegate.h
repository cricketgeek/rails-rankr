//
//  Rails_RankrAppDelegate.h
//  Rails Rankr
//
//  Created by Mark Jones on 4/4/09.
//  Copyright Geordie Enterprises LLC 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Rails_RankrAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
