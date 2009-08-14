//
//  CoderGroup.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/12/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "CoderGroup.h"
#import "Pluralizer.h"

@implementation CoderGroup

@synthesize name, points, formattedPoints, rank, numberOfCoders;

- (id)initWithDictionary:(NSDictionary*)dict {
  if((self = [super init])) {
    self.rank = [(NSNumber*)[dict objectForKey:@"railsrank"] stringValue];
    NSNumberFormatter* nfplain = [[[NSNumberFormatter alloc] init] autorelease];
    self.points = [nfplain numberFromString:[dict objectForKey:@"total"]];
    NSNumberFormatter* nf = [[[NSNumberFormatter alloc] init] autorelease];
    [nf setNumberStyle:NSNumberFormatterBehavior10_4];
    self.formattedPoints = [nf stringFromNumber:self.points];    
    self.name = [dict objectForKey:@"name"];
    NSString* origingalCoderNumbers = [dict objectForKey:@"count"];
    NSString* coderSuffix = [Pluralizer coderSuffix:origingalCoderNumbers];
    self.numberOfCoders = [NSString stringWithFormat:@"%@ %@", origingalCoderNumbers, coderSuffix];
  }
  return self;
}

@end
