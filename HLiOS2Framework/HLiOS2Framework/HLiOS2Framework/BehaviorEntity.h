//
//  BehaviorEntity.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface BehaviorEntity : Entity
{
    NSString *eventName;
	NSString *functionObjectID;
	NSString *functionName;
    NSString *value;
	Boolean	 isRepeat;
}

@property (nonatomic ,retain) NSString *eventName;
@property (nonatomic ,retain) NSString *functionObjectID;
@property (nonatomic ,retain) NSString *functionName;
@property (nonatomic ,retain) NSString *value;
@property (nonatomic ,retain) NSString *behaviorValue;
@property  Boolean  isRepeat;
@end
