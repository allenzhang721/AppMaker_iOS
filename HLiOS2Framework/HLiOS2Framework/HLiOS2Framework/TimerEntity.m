//
//  TimerEntity.m
//  MoueeiOS2Framework
//
//  Created by Pi Yi on 4/23/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "TimerEntity.h"
#import "AnimationDecoder.h"

@implementation TimerEntity
@synthesize  isDesOrder;
@synthesize  isMilliCount;
@synthesize  isStatic;
@synthesize  fontSize;
@synthesize  maxValue;
@synthesize  color;

-(void) decode:(TBXMLElement *)container
{
    TBXMLElement *component  = [EMTBXML childElementNamed:@"Component"  parentElement:container];
    TBXMLElement *data       = [EMTBXML childElementNamed:@"Data"  parentElement:component];
    TBXMLElement *order      = [EMTBXML childElementNamed:@"isPlayOrderbyDesc"  parentElement:data];
    self.isDesOrder          = [[EMTBXML textForElement:order] boolValue];
    TBXMLElement *isms       = [EMTBXML childElementNamed:@"isPlayMillisecond"  parentElement:data];
    self.isMilliCount        = [[EMTBXML textForElement:isms] boolValue];
    TBXMLElement *isst       = [EMTBXML childElementNamed:@"isStaticType"  parentElement:data];
    self.isStatic            = [[EMTBXML textForElement:isst] boolValue];
    TBXMLElement *maxt       = [EMTBXML childElementNamed:@"maxTimer"  parentElement:data];
    if ([[EMTBXML textForElement:maxt] isEqualToString:@"NaN"])
    {
        self.maxValue = 60;
    }
    else
    {
        self.maxValue            = [[EMTBXML textForElement:maxt] intValue];
    }
    
    TBXMLElement *fontColor  = [EMTBXML childElementNamed:@"fontColor"  parentElement:data];
    self.color               = [EMTBXML textForElement:fontColor];
    TBXMLElement *fs         = [EMTBXML childElementNamed:@"fontSize"  parentElement:data];
    self.fontSize            = [[EMTBXML textForElement:fs] intValue];
    float sy = [AnimationDecoder getSY];
    self.fontSize            = self.fontSize *sy;
}

- (void)dealloc
{
    [self.color release];
    [super dealloc];
}
@end
