//
//  SphereViewEntity.m
//  Core
//
//  Created by mac on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SphereViewEntity.h"

@implementation SphereViewEntity
@synthesize images;
@synthesize isLoop;
@synthesize isVertical;
@synthesize speed;
@synthesize isAutoRotation;
@synthesize isClockWise;
@synthesize isAllowZoom;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.isLoop = NO;
        self.isVertical = NO;
        self.isAutoRotation = NO;
        self.images = [[NSMutableArray alloc] initWithCapacity:5];
        [self.images release];
    }
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    TBXMLElement *souceid    = [EMTBXML childElementNamed:@"sourceID"  parentElement:moduleData];
    while (souceid != nil)
    {
        NSString *simg = [EMTBXML textForElement:souceid];
        [self.images addObject:simg];
        souceid = [EMTBXML nextSiblingNamed:@"sourceID" searchFromElement:souceid];
    }
    TBXMLElement *sp    = [EMTBXML childElementNamed:@"Speed"  parentElement:moduleData];
    if (sp != nil)
    {
        self.speed = [[EMTBXML textForElement:sp] intValue];
    }
    else
    {
        self.speed = 5;
    }
    
    TBXMLElement *isAutoRotate = [EMTBXML childElementNamed:@"IsAutoRotation"  parentElement:moduleData];
    if (isAutoRotate)
    {
        self.isAutoRotation = [[EMTBXML textForElement:isAutoRotate] boolValue];
    }
    
    TBXMLElement *rotationType = [EMTBXML childElementNamed:@"RotationType"  parentElement:moduleData];
    if (rotationType)
    {
        NSString *rotationTypeStr = [EMTBXML textForElement:rotationType];
        if ([rotationTypeStr isEqualToString:@"clockwise"])
        {
            self.isClockWise = YES;
        }
        else
        {
            self.isClockWise = NO;
        }
    }
    
    TBXMLElement *isHorSliderElement = [EMTBXML childElementNamed:@"IsHorSlider" parentElement:moduleData];//水平还是垂直滚动2.13 adward
    if (isHorSliderElement)
    {
        NSString *isHorSliderStr = [EMTBXML textForElement:isHorSliderElement];
        if ([isHorSliderStr isEqualToString:@"true"])
        {
            self.isVertical = NO;
        }
        else
        {
            self.isVertical = YES;
        }
    }
    
    TBXMLElement *isAllowUserZoom = [EMTBXML childElementNamed:@"IsAllowZoom" parentElement:moduleData];//是否允许随手指放大2.13 adward
    if (isAllowUserZoom)
    {
        NSString *isAllowZoomStr = [EMTBXML textForElement:isAllowUserZoom];
        if ([isAllowZoomStr isEqualToString:@"true"])
        {
            self.isAllowZoom = YES;
        }
        else
        {
            self.isAllowZoom = NO;
        }
    }
    
    
    [pool release];
}

-(void)dealloc
{
    [super dealloc];
}
@end
