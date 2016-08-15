//
//  CarouselEntity.m
//  Core
//
//  Created by mac on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CarouselEntity.h"
#import "AnimationDecoder.h"

@implementation CarouselEntity
@synthesize cwidth;
@synthesize cheight;
@synthesize images;
@synthesize type;
@synthesize timerDelay;

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.timerDelay = 0;
        self.images = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    float sx = [AnimationDecoder getSX];
    float sy = [AnimationDecoder getSY];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    TBXMLElement *souceid    = [EMTBXML childElementNamed:@"sourceID"  parentElement:moduleData];
    while (souceid != nil)
    {
        NSString *simg = [EMTBXML textForElement:souceid];
        [self.images addObject:simg];
        NSLog(@"%@",simg);
        souceid = [EMTBXML nextSiblingNamed:@"sourceID" searchFromElement:souceid];
        
    }
    self.cwidth = [[EMTBXML textForElement:[EMTBXML childElementNamed:@"itemWidth"  parentElement:moduleData]] floatValue];
    self.cheight = [[EMTBXML textForElement:[EMTBXML childElementNamed:@"itemHeight"  parentElement:moduleData]] floatValue];
    self.cwidth = self.cwidth*sx;
    self.cheight =self.cheight*sy;
    TBXMLElement *timerDelayElement = [EMTBXML childElementNamed:@"TimerDelay" parentElement:moduleData];
    if (timerDelayElement)
    {
        self.timerDelay = [[EMTBXML textForElement:timerDelayElement] intValue];
    }
    [pool release];
}

- (void)dealloc
{
    [self.images removeAllObjects];
    [self.images release];
    [self.type release];
    [super dealloc];
}

@end
