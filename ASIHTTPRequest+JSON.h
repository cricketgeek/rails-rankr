//
//  ASIHTTPRequest+JSON.h
//  GeoTest
//
//  Created by Christopher Burnett on 7/2/09.
//  Copyright 2009 digital scientists, llc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface ASIHTTPRequestJSON : ASIHTTPRequest {
	NSDictionary		*responseJSON;
	NSMutableArray	*responseCollection;
}
@property(nonatomic,retain) NSDictionary		*responseJSON;
@property(nonatomic,retain) NSMutableArray	*responseCollection;
-(NSMutableArray*)getCoderCollection;
-(NSMutableArray*)getCompanyCollection;
-(NSMutableArray*)getCityCollection;

@end
