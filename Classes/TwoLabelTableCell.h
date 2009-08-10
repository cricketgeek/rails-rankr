//
//  TwoLabelTableCell.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/9/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TwoLabelTableCell : UITableViewCell {
  UILabel* leftLabel;
  UILabel* rightLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *leftLabel;
@property (nonatomic, retain) IBOutlet UILabel *rightLabel;

@end
