//
//  CompanyCell.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/9/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CompanyCell : UITableViewCell {
    UILabel* nameLabel;
    UILabel* rankLabel;
    UILabel* railsRankPointsLabel;
    UILabel* coderNumberLabel;
    UIImageView* profileImage;
  }
  
  @property(nonatomic, retain) IBOutlet  UILabel* nameLabel;
  @property(nonatomic, retain) IBOutlet UILabel* rankLabel;
  @property(nonatomic, retain) IBOutlet UILabel* coderNumberLabel;
  @property (nonatomic, retain) IBOutlet UIImageView* profileImage;
  @property (nonatomic, retain) IBOutlet UILabel *railsRankPointsLabel;
  
@end