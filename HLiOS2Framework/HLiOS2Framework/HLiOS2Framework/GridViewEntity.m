//
//  GridViewEntity.m
//  Core
//
//  Created by mac on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GridViewEntity.h"

@implementation GridViewEntity

@synthesize cellHeight;
@synthesize cellWidth;
@synthesize shelfID;
@synthesize shelfType;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.shelfType = 1;
    }
    
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    TBXMLElement *bookwidth    = [EMTBXML childElementNamed:@"BookWidth"  parentElement:moduleData];
    if (bookwidth)
    {
        self.cellWidth = [[EMTBXML textForElement:bookwidth] floatValue];
    }
    TBXMLElement *bookheight = [EMTBXML childElementNamed:@"BookHeight"  parentElement:moduleData];
    if (bookheight)
    {
        self.cellHeight = [[EMTBXML textForElement:bookheight] floatValue];
    }
    TBXMLElement *shelfid = [EMTBXML childElementNamed:@"ShelfID"  parentElement:moduleData];
    if (shelfid)
    {
        self.shelfID = [[EMTBXML textForElement:shelfid] intValue];
    }
    [pool release];
}

-(void)dealloc
{
    [self.serverAdd release];
    [super dealloc];
}

@end
