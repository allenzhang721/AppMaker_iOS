//
//  ContainerEntity.m
//  MoueeiPad
//
//  Created by FloatBits on 7/18/11.
//  Copyright 2011 FloatBits. All rights reserved.
//

#import "ContainerEntity.h"


@implementation ContainerEntity

@synthesize name;
@synthesize fileName;
@synthesize x;
@synthesize y;
@synthesize width;
@synthesize height;
@synthesize rotation;
@synthesize behaviors;
@synthesize	animations;
@synthesize dataid;
@synthesize rootPath;
@synthesize isHideAtBegining;
@synthesize isPlayAtBegining;
@synthesize isPlayAnimationAtBegining;
@synthesize isPlayAudioOrVideoAtBegining;
@synthesize isPlayCacheAnimationAtBegining;
@synthesize isPlayCacheAudioOrVideoAtBegining;
@synthesize isLoopPlay;
@synthesize isPushBack;
@synthesize beLinkageArray;


@synthesize isStroyTelling; //陈星宇，10.24,轨迹
@synthesize stroyTellPt;

-(id) init
{
	self = [super init];
	if (self != nil) 
	{
		behaviors  = [[NSMutableArray alloc] initWithCapacity:10];
		animations = [[NSMutableArray alloc] initWithCapacity:10];
        stroyTellPt = [[NSMutableArray alloc] initWithCapacity:10]; //陈星宇
        beLinkageArray = [[NSMutableArray alloc] initWithCapacity:10];//Adward
        
        self.isHideAtBegining = NO;
        self.isPlayAtBegining = YES;
        self.isLoopPlay       = NO;
        self.isPlayCacheAnimationAtBegining    = NO;
        self.isPlayCacheAudioOrVideoAtBegining = NO;
        self.isUseSlide                        = NO;
        self.repeatCount = 1;
        self.isStroyTelling = NO;
//        self.sliderX = [NSNumber numberWithInt:460];
//        self.sliderY = [NSNumber numberWithInt:334];
//        self.sliderWidth = [NSNumber numberWithInt:100];
//        self.sliderHeight = [NSNumber numberWithInt:100];
	}
	return self;
}

-(void) decode:(TBXMLElement *)container
{
    
}

-(void) decodeData:(TBXMLElement *)data
{
    
}

- (void)dealloc 
{
//	self.name = nil;
//	self.fileName = nil;
//    self.sliderX = nil;
//    self.sliderY = nil;
//    self.sliderWidth = nil;
//    self.sliderHeight = nil;
//    self.alpha = nil;
//    self.sliderAlpha = nil;
//	self.x = nil;;
//	self.y = nil;
//	self.width  = nil;
//	self.height = nil;
//	self.rotation = nil;
//    self.beLinkageArray = nil;
    [self.name release];
    [self.fileName release];
    [self.sliderX release];
    [self.sliderY release];
    [self.sliderWidth release];
    [self.sliderHeight release];
    [self.alpha release];
    [self.sliderAlpha release];
    [self.x release];
    [self.y release];
    [self.width release];
    [self.height release];
    [self.rotation release];
    [self.beLinkageArray removeAllObjects];
    [self.beLinkageArray release];
	[self.behaviors removeAllObjects];
    [self.behaviors release];
    [self.animations removeAllObjects];
	[self.animations release];
    [self.stroyTellPt removeAllObjects];
    [self.stroyTellPt release];
    [self.dataid release];
//	self.dataid = nil;	
    [super dealloc];
}




@end
