//
//  SliceEntity.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-5.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "SliceEntity.h"

@implementation SliceEntity

- (id)init
{
    self = [super init];
    if (self)
    {
        self.imagePathArr = [[[NSMutableArray alloc] init] autorelease];
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
        [self.imagePathArr addObject:simg];
        souceid = [EMTBXML nextSiblingNamed:@"sourceID" searchFromElement:souceid];
    }
    
    [pool release];
}

-(void)dealloc
{
    [self.imagePathArr release];
    [super dealloc];
}

@end
