//
//  CompanyDetailViewController.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/5/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"

@interface CompanyDetailViewController : UIViewController {
  Company* company;
}

@property (nonatomic, retain) Company *company;

@end
