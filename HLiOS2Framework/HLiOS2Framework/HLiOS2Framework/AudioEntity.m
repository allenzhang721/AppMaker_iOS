//
//  AudioEntity.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AudioEntity.h"

@implementation AudioEntity

@synthesize isAutoLoop;
@synthesize isControlBarShow;
- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        self.isAutoLoop = NO;
        self.isOnlineSource = NO;//added by Adward 13-12-06
    }
    
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *autoLoop = [EMTBXML textForElement:[EMTBXML childElementNamed:@"AutoLoop" parentElement:data]];
    
    if ([EMTBXML childElementNamed:@"IsOnlineSource" parentElement:data]) {           //陈星宇，11.8
        TBXMLElement *isOnlineSource = [EMTBXML childElementNamed:@"IsOnlineSource" parentElement:data];
        self.isOnlineSource = [[EMTBXML textForElement:isOnlineSource] boolValue];
    }
    
    TBXMLElement *delayCount = [EMTBXML childElementNamed:@"Delay" parentElement:data];
    if (delayCount)
    {
        self.delayCount = [[EMTBXML textForElement:delayCount] floatValue];
    }
    else
    {
        self.delayCount = 0;
    }
    self.isAutoLoop = [autoLoop boolValue];
    self.isLoopPlay = self.isAutoLoop;
    
    //added by Adward 13-12-16
    TBXMLElement *VideoControlBarIsShow = [EMTBXML childElementNamed:@"VideoControlBarIsShow" parentElement:data];
    if (VideoControlBarIsShow)
    {
        self.isControlBarShow = [[EMTBXML textForElement:VideoControlBarIsShow] boolValue];
    }
    
    [pool release];
}

- (void)dealloc
{
    [super dealloc];
}
@end
