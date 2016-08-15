//
//  VideoEntity.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "VideoEntity.h"

@implementation VideoEntity

@synthesize isAutoLoop;
@synthesize showControlBar;
@synthesize isOnlineVideo;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.showControlBar = YES;
    }
    
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *autoLoop = [EMTBXML textForElement:[EMTBXML childElementNamed:@"AutoLoop" parentElement:data]];
    self.isAutoLoop = [autoLoop boolValue];
    self.isLoopPlay = self.isAutoLoop;
    TBXMLElement *delayCount = [EMTBXML childElementNamed:@"Delay" parentElement:data];
    if (delayCount)
    {
        self.delayCount = [[EMTBXML textForElement:delayCount] floatValue];
    }
    else
    {
        self.delayCount = 0;
    }
    TBXMLElement *showBar = [EMTBXML childElementNamed:@"VideoControlBarIsShow" parentElement:data];
    if (showBar)
    {
        NSString *showStr = [EMTBXML textForElement:showBar];
        self.showControlBar = [showStr boolValue];
    }
    TBXMLElement *cover = [EMTBXML childElementNamed:@"CoverSourceID" parentElement:data];
    if (cover)
    {
        self.coverName = [EMTBXML textForElement:cover];
    }
    
    //added by Adward 13-11-07
    TBXMLElement *isOnlineVideoElement = [EMTBXML childElementNamed:@"IsOnlineSource" parentElement:data];
    if (isOnlineVideoElement)
    {
        self.isOnlineVideo = [[EMTBXML textForElement:isOnlineVideoElement] boolValue];
    }
    
    [pool release];
}

- (void)dealloc
{
    [self.coverName release];
    [super dealloc];
}

@end
