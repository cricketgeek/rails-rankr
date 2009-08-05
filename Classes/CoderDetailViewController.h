//
//  CoderDetailViewController.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/5/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coder.h"

@interface CoderDetailViewController : UIViewController {
  Coder* coder;
}

@property (nonatomic, retain) Coder *coder;

@end
