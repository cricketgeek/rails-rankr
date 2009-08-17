//
//  CoderCell.h
//  Rails Rankr
//
//  Created by Mark Jones on 4/12/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CoderCell : UITableViewCell {
  UILabel* nameLabel;
  UILabel* rankLabel;
  UILabel* hasUpdatesLabel;
  UILabel* railsRankPointsLabel;
  UILabel* cityLabel;
  UIImageView* profileImage;
}

@property (nonatomic, retain) IBOutlet UILabel* hasUpdatesLabel;
@property(nonatomic, retain) IBOutlet  UILabel* nameLabel;
@property(nonatomic, retain) IBOutlet UILabel* rankLabel;
@property(nonatomic, retain) IBOutlet UILabel* cityLabel;
@property (nonatomic, retain) IBOutlet UIImageView* profileImage;
@property (nonatomic, retain) IBOutlet UILabel *railsRankPointsLabel;

@end
