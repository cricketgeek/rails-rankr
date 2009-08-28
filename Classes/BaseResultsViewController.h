//
//  BaseResultsViewController.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/6/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseResultsViewController : UIViewController {
  BOOL gettingDataNow;
  UIActivityIndicatorView* spinner;
}

@property (nonatomic, retain) UIActivityIndicatorView *spinner;

-(void)hideNetworkUnavailableView;
-(void)showNetworkUnavailableView;
@end
