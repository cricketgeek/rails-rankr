//
//  Pluralizer.m
//  Rails Rankr
//
//  Created by Mark Jones on 8/12/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "Pluralizer.h"


@implementation Pluralizer

+(NSString*)coderSuffix:(NSString*)stringCount {
  NSNumberFormatter* nf = [[[NSNumberFormatter alloc] init] autorelease];
  NSNumber* coderNumber = [nf numberFromString:stringCount];
  NSString* coderSuffix = [coderNumber intValue] > 1 ? @"coders" : @"coder";
  return coderSuffix;
}

@end
