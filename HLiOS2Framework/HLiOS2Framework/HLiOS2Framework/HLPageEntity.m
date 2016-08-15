//
//  PageEntity.m
//  MoueeiPad
//
//  Created by FloatBits on 7/18/11.
//  Copyright 2011 FloatBits. All rights reserved.
//

#import "HLPageEntity.h"


@implementation HLPageEntity
@synthesize title;
@synthesize description;
@synthesize width;
@synthesize height;
@synthesize containers;
@synthesize background;
@synthesize groups;
@synthesize groupDelay;
@synthesize enbableNavigation;
@synthesize navPages;
@synthesize isVerticalPageType;
@synthesize linkPageID;
@synthesize isGroupPlay;
@synthesize isCached;
@synthesize cacheImageID;
@synthesize isLoaded;
@synthesize enableGesture;

//added by Adward 13-11-27
@synthesize animationDir;
@synthesize animationDuration;
@synthesize animationType;

@synthesize isNeedPay;  //陈星宇

//      >>>>>   12.27, 公共页
@synthesize state;
@synthesize beCoveredPageID;
@synthesize CoverPageIds;
//      <<<<<

-(id) init
{
	self = [super init];
	if (self != nil) 
	{
		self.containers = [[NSMutableArray alloc] initWithCapacity:10];
        self.groups     = [[NSMutableArray alloc] initWithCapacity:10];
        self.groupDelay = [[NSMutableArray alloc] initWithCapacity:10];
        self.navPages   = [[NSMutableArray alloc] initWithCapacity:10];
        self.CoverPageIds = [[NSMutableArray alloc] initWithCapacity:10];
        self.enbableNavigation  = YES;
        self.isVerticalPageType = NO;
        self.isCached           = YES;
        self.isLoaded           = NO;
        self.enableGesture      = YES;
        self.isUseSlide         = NO;
        //added by Adward 13-11-27
        self.animationType      = nil;
        self.animationDuration  = nil;
        self.animationType      = nil;
        
        self.isNeedPay          = NO;   //陈星宇
	}
	return self;
}

- (void)dealloc 
{
	self.title = nil;
	self.description = nil;
    [self.linkPageID release];
    [self.cacheImageID release];
	[self.width release];
	[self.height release];
    [self.groups removeAllObjects];
    [self.groups release];
    [self.navPages removeAllObjects];
    [self.navPages release];
    [self.groupDelay removeAllObjects];
    [self.groupDelay release];
	[self.containers removeAllObjects];
	[self.containers release];
    [self.background release];
    [self.animationType release];
    [self.animationDir release];
    [self.animationDuration release];
    [self.stateString release];
    [self.beCoveredPageID release];
    [self.CoverPageIds release];
    
    [super dealloc];
}
@end
