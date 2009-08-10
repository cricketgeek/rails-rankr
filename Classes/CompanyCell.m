//
//  CompanyCell.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/9/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "CompanyCell.h"


@implementation CompanyCell

@synthesize nameLabel, rankLabel, coderNumberLabel, profileImage, railsRankPointsLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
    // Initialization code
  }
  return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}


- (void)dealloc {
  [nameLabel release];
  [rankLabel release];
  [railsRankPointsLabel release];
  [coderNumberLabel release];
  [super dealloc];
}


@end
