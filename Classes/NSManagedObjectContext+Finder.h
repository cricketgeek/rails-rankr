//
//  NSManagedObjectContext+Finder.h
//  NannyFeedMe_ver1
//
//  Created by Mark Jones on 8/18/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

@interface NSManagedObjectContext (Finder)
- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName
                       withPredicate:(id)stringOrPredicate, ...;
@end
