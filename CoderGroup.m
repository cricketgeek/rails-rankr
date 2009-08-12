//
//  CoderGroup.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/12/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "CoderGroup.h"


@implementation CoderGroup

@synthesize name, points, formattedPoints, rank, numberOfCoders;

- (id)initWithDictionary:(NSDictionary*)dict {
  if((self = [super init])) {
    self.rank = [(NSNumber*)[dict objectForKey:@"railsrank"] stringValue];
    NSNumberFormatter* nfplain = [[NSNumberFormatter alloc] init];
    self.points = [nfplain numberFromString:[dict objectForKey:@"total"]];
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterBehavior10_4];
    self.formattedPoints = [nf stringFromNumber:(NSNumber*)[dict objectForKey:@"total"]];    
    self.name = [dict objectForKey:@"company_name"];
    self.numberOfCoders = [dict objectForKey:@"count"];
  }
  return self;
}

@end
