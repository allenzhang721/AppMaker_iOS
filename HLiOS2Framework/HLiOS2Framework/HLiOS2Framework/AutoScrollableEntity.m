//
//  AutoScrollableEntity.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-9-10.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "AutoScrollableEntity.h"

@implementation AutoScrollableEntity

@synthesize images;
@synthesize timerDelay;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.timerDelay = 0;
        self.images = [[NSMutableArray alloc] initWithCapacity:5];
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

    TBXMLElement *timerDelayElement = [EMTBXML childElementNamed:@"TimerDelay" parentElement:moduleData];
    if (timerDelayElement)
    {
        self.timerDelay = [[EMTBXML textForElement:timerDelayElement] intValue];
    }
    [pool release];
}

- (void)dealloc
{
    [self.images release];
    [super dealloc];
}


@end
