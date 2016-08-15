//
//  HorConnectLineEntity.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-8.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HorConnectLineEntity.h"

@implementation HorConnectLineEntity

-(id)init
{
    self = [super init];
    if (self)
    {
        self.answerArray = [[[NSMutableArray alloc] init] autorelease];
        self.sourceArray = [[[NSMutableArray alloc] init] autorelease];
        self.idArray = [[[NSMutableArray alloc] init] autorelease];
        //added by Adward 13-11-22
        self.lineAlpha = 1;
        self.lineColor = [NSString stringWithFormat:@"1"];
        self.lineWidth = 1;
    }
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    //added by Adward 13-11-22
    TBXMLElement *line = [EMTBXML childElementNamed:@"Line" parentElement:moduleData];
    if (line)
    {
        TBXMLElement *lineColorElement = [EMTBXML childElementNamed:@"LineColor" parentElement:line];
        self.lineColor = [EMTBXML textForElement:lineColorElement];
        TBXMLElement *lineThicknessElement = [EMTBXML childElementNamed:@"LineThickness" parentElement:line];
        self.lineWidth = [[EMTBXML textForElement:lineThicknessElement] intValue];
        TBXMLElement *lineAlphaElement = [EMTBXML childElementNamed:@"LineAlpha" parentElement:line];
        self.lineAlpha = [[EMTBXML textForElement:lineAlphaElement] floatValue];
    }
    
    TBXMLElement *rows = [EMTBXML childElementNamed:@"Rows" parentElement:moduleData];
    TBXMLElement *row = [EMTBXML childElementNamed:@"Row" parentElement:rows];
    for (int i = 0; row != nil; ++i)
    {
        TBXMLElement *subElement = [EMTBXML childElementNamed:@"UpCell"parentElement:row];
        if (subElement)
        {
            TBXMLElement *id = [EMTBXML childElementNamed:@"CellID"parentElement:subElement];
            TBXMLElement *linkId = [EMTBXML childElementNamed:@"LinkID"parentElement:subElement];
            TBXMLElement *sourceId = [EMTBXML childElementNamed:@"SourceID"parentElement:subElement];
            NSString *idStr = [EMTBXML textForElement:id];
            NSString *linkIdStr = [EMTBXML textForElement:linkId];
            NSString *sourceIdStr = [EMTBXML textForElement:sourceId];
            [_answerArray addObject:linkIdStr];
            [_sourceArray addObject:sourceIdStr];
            [_idArray addObject:idStr];
        }
        subElement = [EMTBXML childElementNamed:@"DownCell"parentElement:row];
        if (subElement)
        {
            TBXMLElement *id = [EMTBXML childElementNamed:@"CellID"parentElement:subElement];
            TBXMLElement *linkId = [EMTBXML childElementNamed:@"LinkID"parentElement:subElement];
            TBXMLElement *sourceId = [EMTBXML childElementNamed:@"SourceID"parentElement:subElement];
            NSString *idStr = [EMTBXML textForElement:id];
            NSString *linkIdStr = [EMTBXML textForElement:linkId];
            NSString *sourceIdStr = [EMTBXML textForElement:sourceId];
            [_answerArray addObject:linkIdStr];
            [_sourceArray addObject:sourceIdStr];
            [_idArray addObject:idStr];
        }
        row = [EMTBXML nextSiblingNamed:@"Row" searchFromElement:row];
    }
    TBXMLElement *lineGap = [EMTBXML childElementNamed:@"LineGap" parentElement:moduleData];
    TBXMLElement *rowGap = [EMTBXML childElementNamed:@"RowGap" parentElement:moduleData];
    
    self.lineGap = [[EMTBXML textForElement:lineGap] floatValue];
    self.rowGap = [[EMTBXML textForElement:rowGap] floatValue];
    
    [pool release];
}

-(void)dealloc
{
    [_answerArray release];
    [_sourceArray release];
    [_idArray release];
    [super dealloc];
}

@end
