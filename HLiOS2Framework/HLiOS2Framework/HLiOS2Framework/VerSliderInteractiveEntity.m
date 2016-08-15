//
//  VerSliderInteractiveEntity.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-12.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "VerSliderInteractiveEntity.h"

@implementation VerSliderInteractiveEntity

- (id)init
{
    self = [super init];
    if (self)
    {
        self.itemArray = [[[NSMutableArray alloc] init] autorelease];
        
    }
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    TBXMLElement *sourceID    = [EMTBXML childElementNamed:@"sourceID"  parentElement:moduleData];
    while (sourceID != nil)
    {
        NSString *idStr = [EMTBXML textForElement:sourceID];
        [self.itemArray addObject:idStr];
        sourceID = [EMTBXML nextSiblingNamed:@"sourceID" searchFromElement:sourceID];
    }
    
    [pool release];
}

- (void)dealloc
{
    self.itemArray = nil;
    [super dealloc];
}

@end
