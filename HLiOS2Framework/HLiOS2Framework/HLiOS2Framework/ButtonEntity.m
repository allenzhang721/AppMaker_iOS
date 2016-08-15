//
//  ButtonEntity.m
//  Core
//
//  Created by Pi Yi on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ButtonEntity.h"

@implementation ButtonEntity
@synthesize btnImg;
@synthesize btnHighlightImg;
@synthesize x;
@synthesize y;
@synthesize width;
@synthesize height;
@synthesize isVisible;
@synthesize isUserDef;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        self.isVisible = YES;
        self.isUserDef = NO;
    }
    return self;
}

- (void)dealloc
{
	self.btnImg = nil;
    [self.btnHighlightImg release];
    [super dealloc];
}

@end
