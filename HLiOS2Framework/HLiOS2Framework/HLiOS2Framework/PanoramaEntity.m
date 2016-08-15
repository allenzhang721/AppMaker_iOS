//
//  PanoramaEntity.m
//  Core
//
//  Created by mac on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PanoramaEntity.h"

@implementation PanoramaEntity

@synthesize img;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    TBXMLElement *souceid    = [EMTBXML childElementNamed:@"sourceID"  parentElement:moduleData];
    self.img = [EMTBXML textForElement:souceid];
    [pool release];
}

- (void)dealloc
{
    [self.img release];
    [super dealloc];
}

@end
