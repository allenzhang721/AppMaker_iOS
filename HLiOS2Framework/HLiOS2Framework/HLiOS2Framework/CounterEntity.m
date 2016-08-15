//
//  CounterEntity.m
//  MoueeiOS2Framework
//
//  Created by Pi Yi on 4/23/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "CounterEntity.h"
#import "AnimationDecoder.h"

@implementation CounterEntity
@synthesize isGlobal;
@synthesize fontSize;
@synthesize fontColor;
@synthesize minValue;
@synthesize maxValue;

-(void) decode:(TBXMLElement *)container
{
    TBXMLElement *component  = [EMTBXML childElementNamed:@"Component"  parentElement:container];
    TBXMLElement *data       = [EMTBXML childElementNamed:@"Data"  parentElement:component];
    TBXMLElement *scope = [EMTBXML childElementNamed:@"scope"  parentElement:data];
    NSString *sc        = [EMTBXML textForElement:scope];
    if ([sc isEqualToString:@"global"] == YES)
    {
        self.isGlobal  = YES;
    }
    else
    {
        self.isGlobal = NO;
    }
    TBXMLElement *fs = [EMTBXML childElementNamed:@"fontSize"  parentElement:data];
    self.fontSize          = [[EMTBXML textForElement:fs] intValue];
    TBXMLElement *fc = [EMTBXML childElementNamed:@"fontColor"  parentElement:data];
    self.fontColor         = [EMTBXML textForElement:fc];
    TBXMLElement *mv = [EMTBXML childElementNamed:@"minValue"  parentElement:data];
    self.minValue    = [[EMTBXML textForElement:mv] intValue];
    TBXMLElement *maxv = [EMTBXML childElementNamed:@"maxValue"  parentElement:data];
    self.maxValue    = [[EMTBXML textForElement:maxv] intValue];
    float sy = [AnimationDecoder getSY];
    self.fontSize            = self.fontSize *sy;
}

- (void)dealloc
{
    [self.fontColor release];
    [super dealloc];
}
@end
