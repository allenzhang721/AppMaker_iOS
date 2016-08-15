//
//  PaintEntity.m
//  Core
//
//  Created by user on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PaintEntity.h"


@implementation PaintEntity

@synthesize img;
@synthesize lineWidth;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.lineWidth = 1.0;
    }
    
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    TBXMLElement *souceid    = [EMTBXML childElementNamed:@"sourceID"  parentElement:moduleData];
    self.img = [EMTBXML textForElement:souceid];
    if ([EMTBXML childElementNamed:@"lineThickness" parentElement:moduleData])
    {
        TBXMLElement *lineThickness = [EMTBXML childElementNamed:@"lineThickness" parentElement:moduleData];
        self.lineWidth = [[EMTBXML textForElement:lineThickness] intValue];//added by Adward 13-12-06
    }
    [pool release];
}

- (void)dealloc
{
    [self.img release];
    [super dealloc];
}
@end
