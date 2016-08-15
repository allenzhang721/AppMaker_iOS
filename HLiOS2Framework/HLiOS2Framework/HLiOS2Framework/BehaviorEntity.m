//
//  BehaviorEntity.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BehaviorEntity.h"

@implementation BehaviorEntity

@synthesize eventName;
@synthesize functionObjectID;
@synthesize functionName;
@synthesize value;
@synthesize isRepeat;
@synthesize behaviorValue;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc 
{
   // NSLog(@"Behavior Dealloc");
	[self.eventName release];
    [self.functionName release];
    [self.functionObjectID release];
    [self.behaviorValue release];
    [self.value release];
    [super dealloc];
}

@end
