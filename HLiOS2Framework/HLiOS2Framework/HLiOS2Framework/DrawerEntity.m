//
//  DrawerEntity.m
//  Core
//
//  Created by sun yongle on 25/07/12.
//  Copyright (c) 2012年 PEM. All rights reserved.
//

#import "DrawerEntity.h"

@implementation DrawerEntity

@synthesize segCount;
@synthesize btnPic;
@synthesize btnSelPic;
@synthesize segBtnPics;
@synthesize segBtnSelPics;


-(id)init
{
    self = [super init];
    if (self) 
    {
        self.segCount = 4;
        self.segBtnPics = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
        self.segBtnSelPics = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
    }
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    TBXMLElement *souceid    = [EMTBXML childElementNamed:@"renderer"  parentElement:moduleData];
    NSString *imageName = @"";
    if (souceid)
    {
        TBXMLElement *subElement = [EMTBXML childElementNamed:@"mouseUpSourceID"parentElement:souceid];
        if (subElement)
        {
            imageName = [EMTBXML textForElement:subElement];
            self.btnPic = imageName;
        }
        subElement = [EMTBXML childElementNamed:@"mouseDownSourceID"parentElement:souceid];
        if (subElement)
        {
            imageName = [EMTBXML textForElement:subElement];
            self.btnSelPic = imageName;
        }
    }
    if (souceid != nil)
    {
        souceid = [EMTBXML nextSiblingNamed:@"renderer" searchFromElement:souceid];
    }
    
    for (int i = 0; souceid != nil; ++i)
    {
        TBXMLElement *subElement = [EMTBXML childElementNamed:@"mouseUpSourceID"parentElement:souceid];
        if (subElement)
        {
            imageName = [EMTBXML textForElement:subElement];
            [self.segBtnPics addObject:imageName];
        }
        subElement = [EMTBXML childElementNamed:@"mouseDownSourceID"parentElement:souceid];
        if (subElement)
        {
            imageName = [EMTBXML textForElement:subElement];
            [self.segBtnSelPics addObject:imageName];
        }
        souceid = [EMTBXML nextSiblingNamed:@"renderer" searchFromElement:souceid];
    }
    NSInteger count = self.segBtnPics.count;
    self.segCount = count;
    [pool release];
}

-(void)dealloc
{
    [self.btnPic release];
    [self.btnSelPic release];
    [self.segBtnPics release];
    [self.segBtnSelPics release];
    
    [super dealloc];
}

@end
