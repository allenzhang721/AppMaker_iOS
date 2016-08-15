//
//  Entity.m
//  Core
//
//  Created by user on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HLBaseEntity.h"

@implementation HLBaseEntity

@synthesize entityid;

- (void)dealloc 
{
    self.entityid = nil;
    [super dealloc];
}
@end
