//
//  City.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/10/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface City : NSObject {
  NSString	* name;
  NSString	* points;
  NSString  * rank;
  NSString  * numberOfCoders;
}

@property (nonatomic , retain) NSString	* name;
@property (nonatomic , retain) NSString	* points;
@property (nonatomic , retain) NSString	* rank;
@property (nonatomic, retain) NSString *numberOfCoders;


@end