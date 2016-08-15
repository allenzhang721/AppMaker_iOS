//
//  iAdEntity.m
//  Core
//
//  Created by Mouee-iMac on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "iAdEntity.h"

@implementation iAdEntity

@synthesize adtype;
@synthesize mogoID;

-(id)init
{
    self = [super init];
    if (self) 
    {
        self.adtype = 0;
    }
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement *element = [EMTBXML childElementNamed:@"ADType" parentElement:data];
    if (element)
    {
        self.adtype = [[EMTBXML textForElement:element] intValue];
    }
    element = [EMTBXML childElementNamed:@"ADID" parentElement:data];
    if (element)
    {
        self.mogoID = [EMTBXML textForElement:element];
    }
    [pool release];
}

-(void)dealloc
{
    [self.mogoID release];
    [super dealloc];
}

@end
