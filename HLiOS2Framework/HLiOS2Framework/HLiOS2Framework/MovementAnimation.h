//
//  MovementAnimation.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animation.h"

@interface MovementAnimation : Animation
{
    NSMutableArray *points;
	Boolean aspect;
}

@property (nonatomic ,retain) NSMutableArray *points;
@property Boolean aspect;

@end
