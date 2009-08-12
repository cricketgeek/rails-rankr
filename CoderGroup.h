//
//  CoderGroup.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/12/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CoderGroup : NSObject {
  NSString	* name;
  NSNumber	* points;
  NSString  * formattedPoints;
  NSString  * rank;
  NSString  * numberOfCoders;  
}

@property (nonatomic , retain) NSString	* name;
@property (nonatomic , retain) NSNumber	* points;
@property (nonatomic, retain) NSString * formattedPoints;
@property (nonatomic , retain) NSString	* rank;
@property (nonatomic, retain) NSString *numberOfCoders;

@end
