//
//  GifEntity.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GifEntity.h"
#import "HLUtility.h"


@implementation GifEntity
@synthesize duration;
@synthesize images;
@synthesize times;
@synthesize isLoop;
@synthesize isStroyTelling;
- (id)init
{
    self = [super init];
    if (self) 
    {
        self.images = [[NSMutableArray alloc] initWithCapacity:10];
        [self.images release];
        self.isLoop = NO;
    }
    
    return self;
}

-(void) decode:(TBXMLElement *)container
{
    TBXMLElement *allowMove = [EMTBXML childElementNamed:@"IsStroyTelling"  parentElement:container];
    self.isStroyTelling     = [HLUtility stringToBoolean:[EMTBXML textForElement:allowMove]];
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *gifDuration   = [EMTBXML textForElement:[EMTBXML childElementNamed:@"GifDuration" parentElement:data]];
    self.duration = [gifDuration doubleValue];
    if ([EMTBXML childElementNamed:@"IsPlayOnetime" parentElement:data])
    {
        NSString *strIsLoop   = [EMTBXML textForElement:[EMTBXML childElementNamed:@"IsPlayOnetime" parentElement:data]];
        self.isLoop = ![strIsLoop boolValue];
    }
    TBXMLElement *gifFrames = [EMTBXML childElementNamed:@"GifFrames"  parentElement:data];
    if (gifFrames != nil)
    {
        TBXMLElement *gifFrame  = [EMTBXML childElementNamed:@"GifFrame"  parentElement:gifFrames];
        while(gifFrame != nil)
        {
            NSString *sourceid  = [EMTBXML textForElement:[EMTBXML childElementNamed:@"LocalSourceID" parentElement:gifFrame]];
            [self.images addObject:sourceid];
            gifFrame = [EMTBXML nextSiblingNamed:@"GifFrame" searchFromElement:gifFrame];
        }
    }
    self.isLoopPlay = self.isLoop;
    [pool release];
}


- (void)dealloc
{
    [self.images removeAllObjects];
    [self.images release];
    [super dealloc];
}

@end
