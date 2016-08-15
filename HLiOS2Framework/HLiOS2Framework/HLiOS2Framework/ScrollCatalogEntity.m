//
//  ScrollCatalogEntity.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-29.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "ScrollCatalogEntity.h"

@implementation ScrollCatalogEntity

- (id)init
{
    self = [super init];
    if (self)
    {
        self.leftArray = [[[NSMutableArray alloc] init] autorelease];
        self.centerArray = [[[NSMutableArray alloc] init] autorelease];
        self.rightArray = [[[NSMutableArray alloc] init] autorelease];
        self.leftIndexArray = [[[NSMutableArray alloc] init] autorelease];
        self.centerIndexArray = [[[NSMutableArray alloc] init] autorelease];
        self.rightIndexArray = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    TBXMLElement *renders    = [EMTBXML childElementNamed:@"LeftRender"  parentElement:moduleData];
    TBXMLElement *render    = [EMTBXML childElementNamed:@"Render"  parentElement:renders];
    while (render != nil)
    {
        TBXMLElement *sourceID = [EMTBXML childElementNamed:@"SourceID" parentElement:render];
        NSString *sourceIDStr = [EMTBXML textForElement:sourceID];
        [self.leftArray addObject:sourceIDStr];
        
        TBXMLElement *sourceIndex = [EMTBXML childElementNamed:@"SourceIndex" parentElement:render];
        NSString *sourceIndexStr = [EMTBXML textForElement:sourceIndex];
        [self.leftIndexArray addObject:sourceIndexStr];
        
        render = [EMTBXML nextSiblingNamed:@"Render" searchFromElement:render];
    }
    
    renders    = [EMTBXML childElementNamed:@"MiddleRender"  parentElement:moduleData];
    render    = [EMTBXML childElementNamed:@"Render"  parentElement:renders];
    while (render != nil)
    {
        TBXMLElement *sourceID = [EMTBXML childElementNamed:@"SourceID" parentElement:render];
        NSString *sourceIDStr = [EMTBXML textForElement:sourceID];
        [self.centerArray addObject:sourceIDStr];
        
        TBXMLElement *sourceIndex = [EMTBXML childElementNamed:@"SourceIndex" parentElement:render];
        NSString *sourceIndexStr = [EMTBXML textForElement:sourceIndex];
        [self.centerIndexArray addObject:sourceIndexStr];
        
        render = [EMTBXML nextSiblingNamed:@"Render" searchFromElement:render];
    }
    
    renders    = [EMTBXML childElementNamed:@"RightRender"  parentElement:moduleData];
    render    = [EMTBXML childElementNamed:@"Render"  parentElement:renders];
    while (render != nil)
    {
        TBXMLElement *sourceID = [EMTBXML childElementNamed:@"SourceID" parentElement:render];
        NSString *sourceIDStr = [EMTBXML textForElement:sourceID];
        [self.rightArray addObject:sourceIDStr];
        
        TBXMLElement *sourceIndex = [EMTBXML childElementNamed:@"SourceIndex" parentElement:render];
        NSString *sourceIndexStr = [EMTBXML textForElement:sourceIndex];
        [self.rightIndexArray addObject:sourceIndexStr];
        
        render = [EMTBXML nextSiblingNamed:@"Render" searchFromElement:render];
    }
    
    [pool release];
}

- (void)dealloc
{
    self.leftArray = nil;
    self.centerArray = nil;
    self.rightArray = nil;
    self.leftIndexArray = nil;
    self.centerIndexArray = nil;
    self.rightIndexArray = nil;
    [super dealloc];
}

@end
