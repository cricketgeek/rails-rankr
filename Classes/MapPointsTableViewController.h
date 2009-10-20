//
//  MapPointsTableViewController.h
//  Rails Rankr
//
//  Created by Mark Jones on 10/20/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapPointsTableViewController : UITableViewController {

  NSManagedObjectContext* managedObjectContext;
  NSMutableArray* data;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *data;

-(void)doneEditing;
-(void)getData;

@end
