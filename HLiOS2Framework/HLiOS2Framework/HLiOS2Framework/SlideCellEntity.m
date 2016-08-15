//
//  SlideCellEntity.m
//  Core
//
//  Created by sun yongle on 12/08/12.
//  Copyright (c) 2012年 PEM. All rights reserved.
//

#import "SlideCellEntity.h"
#import "AnimationDecoder.h"

@implementation SlideCellEntity

@synthesize normalImages;
@synthesize selImages;
@synthesize isVirtical;
@synthesize cellWidth;
@synthesize cellHeight;

- (id)init
{
    self = [super init];
    if (self) 
    {
        normalImages = [[NSMutableArray alloc] initWithCapacity:4];
        selImages = [[NSMutableArray alloc] initWithCapacity:4];
    }
    return self;
}

- (void)dealloc
{
    [normalImages release];
    [selImages release];
    [super dealloc];
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    float sx  = [AnimationDecoder getSX];
    float sy  = [AnimationDecoder getSY];
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    
    TBXMLElement *itemSize = [EMTBXML childElementNamed:@"ItemWidth" parentElement:moduleData];
    if (itemSize)
    {
        self.cellWidth = [[EMTBXML textForElement:itemSize] floatValue]*sx;
    }
    itemSize = [EMTBXML childElementNamed:@"ItemHeight" parentElement:moduleData];
    if (itemSize)
    {
        self.cellHeight = [[EMTBXML textForElement:itemSize] floatValue]*sy;
    }
    
    TBXMLElement *moduledataElement = [EMTBXML childElementNamed:@"Data" parentElement:moduleData];
    TBXMLElement *souceid    = [EMTBXML childElementNamed:@"renderer"  parentElement:moduledataElement];
    NSString *imageName = @"";
    
    for (int i = 0; souceid != nil; ++i)
    {
        TBXMLElement *subElement = [EMTBXML childElementNamed:@"mouseUpSourceID"parentElement:souceid];
        if (subElement)
        {
            imageName = [EMTBXML textForElement:subElement];
            [self.normalImages addObject:imageName];
        }
        subElement = [EMTBXML childElementNamed:@"mouseDownSourceID"parentElement:souceid];
        if (subElement)
        {
            imageName = [EMTBXML textForElement:subElement];
            [self.selImages addObject:imageName];
        }
        souceid = [EMTBXML nextSiblingNamed:@"renderer" searchFromElement:souceid];
    }
    [pool release];
}

@end
