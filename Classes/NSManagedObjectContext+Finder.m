//
//  NSManagedObjectContext+Finder.m
//  NannyFeedMe_ver1
//
//  Created by Mark Jones on 8/18/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "NSManagedObjectContext+Finder.h"


@implementation NSManagedObjectContext (Finder)

- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName
                       withPredicate:(id)stringOrPredicate, ... 
{
  
  NSEntityDescription *entity = [NSEntityDescription
                                 entityForName:newEntityName inManagedObjectContext:self];
  
  NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
  [request setEntity:entity];
  
  if (stringOrPredicate)
  {
    NSPredicate *predicate;
    if ([stringOrPredicate isKindOfClass:[NSString class]])
    {
      va_list variadicArguments;
      va_start(variadicArguments, stringOrPredicate);
      predicate = [NSPredicate predicateWithFormat:stringOrPredicate
                                         arguments:variadicArguments];
      va_end(variadicArguments);
    }
    else
    {
      NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]],
                @"Second parameter passed to %s is of unexpected class %@",
                sel_getName(_cmd), [stringOrPredicate class]);
      predicate = (NSPredicate *)stringOrPredicate;
    }
    [request setPredicate:predicate];
  }
  
  NSError *error = nil;
  NSArray *results = [self executeFetchRequest:request error:&error];
  if (error != nil)
  {
    [NSException raise:NSGenericException format:[error description]];
  }
  
  return [NSSet setWithArray:results];
}

@end
