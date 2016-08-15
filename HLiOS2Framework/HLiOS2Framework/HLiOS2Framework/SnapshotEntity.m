//
//  SnapshotEntity.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SnapshotEntity.h"

@implementation SnapshotEntity

@synthesize pageid;
@synthesize fileid;
@synthesize pageTitle;

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
    [self.pageid release];
    [self.fileid release];
    [self.pageTitle release];
    [super dealloc];
}

@end
