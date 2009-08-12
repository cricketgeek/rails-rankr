//
//  CoderModelsConverter.h
//  Rails Rankr
//
//  Created by Mark Jones on 8/12/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coder.h"
#import "CoreCoder.h"

@interface CoderModelsConverter : NSObject {

}

+(void)coderFromCoreCoder:(Coder*)coder andCoreCoder:(CoreCoder*)coreCoder;
+(void)coreCoderFromCoder:(CoreCoder*)coreCoder andCoder:(Coder*)coder;

@end
