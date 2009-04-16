//
//  CoderCell.m
//  Rails Rankr
//
//  Created by Mark Jones on 4/12/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "CoderCell.h"


@implementation CoderCell
@synthesize nameLabel, rankLabel, cityLabel;

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
    [super dealloc];
    [nameLabel release];
    [rankLabel release];
    [cityLabel release];
}


@end
