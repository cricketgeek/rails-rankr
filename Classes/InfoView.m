//
//  InfoView.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/14/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "InfoView.h"


@implementation InfoView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touchesBegan");
  [[self parentViewController] dismissModalViewControllerAnimated:YES]; 
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
