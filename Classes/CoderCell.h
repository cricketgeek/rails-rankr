//
//  CoderCell.h
//  Rails Rankr
//
//  Created by Mark Jones on 4/12/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CoderCell : UITableViewCell {
  IBOutlet UILabel* nameLabel;
  IBOutlet UILabel* rankLabel;
  IBOutlet UILabel* cityLabel;
}

@property(nonatomic, retain) UILabel* nameLabel;
@property(nonatomic, retain) UILabel* rankLabel;
@property(nonatomic, retain) UILabel* cityLabel;

@end
