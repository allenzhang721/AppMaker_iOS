//
//  CaseEntity.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-10.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "CaseEntity.h"

@implementation CaseEntity

- (id)init
{
    self = [super init];
    if (self)
    {
        self.containerIdArr = [[[NSMutableArray alloc] init] autorelease];
    }
    
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    TBXMLElement *caseContainers = [EMTBXML childElementNamed:@"CaseContainers"  parentElement:data];
    TBXMLElement *souceid    = [EMTBXML childElementNamed:@"ID"  parentElement:caseContainers];
    while (souceid != nil)
    {
        NSString *simg = [EMTBXML textForElement:souceid];
        [self.containerIdArr addObject:simg];
        souceid = [EMTBXML nextSiblingNamed:@"ID" searchFromElement:souceid];
    }
    
    [pool release];
}

-(void)dealloc
{
    [self.containerIdArr release];
    [super dealloc];
}

@end
