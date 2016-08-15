//
//  ImageEntity.m
//  MoueeiPad
//
//  Created by FloatBits on 7/18/11.
//  Copyright 2011 FloatBits. All rights reserved.
//

#import "ImageEntity.h"
#import "HLUtility.h"


@implementation ImageEntity

@synthesize isZoomByUser;
@synthesize isStroyTelling;
@synthesize type;
@synthesize scale;
@synthesize isMoveScale;
- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        self.type         = nil;
        self.isZoomByUser = NO;
        self.isZoomInner = YES;
        self.scale        = 1.0;
    }
    
    return self;
}

-(void) decode:(TBXMLElement *)container
{
    TBXMLElement *allowMove = [EMTBXML childElementNamed:@"IsStroyTelling"  parentElement:container];
    self.isStroyTelling     = [HLUtility stringToBoolean:[EMTBXML textForElement:allowMove]];
    
    TBXMLElement *moveScale = [EMTBXML childElementNamed:@"IsMoveScale"  parentElement:container];
    if (moveScale)
    {
        self.isMoveScale     = [HLUtility stringToBoolean:[EMTBXML textForElement:moveScale]];
    }
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement *allowUserZoom = [EMTBXML childElementNamed:@"IsAllowUserZoom"  parentElement:data];
    if (allowUserZoom != nil)
    {
        NSString *isAllowUserZoom = [EMTBXML textForElement:allowUserZoom];
        self.isZoomByUser = [isAllowUserZoom boolValue];
    }
    TBXMLElement *zoomType = [EMTBXML childElementNamed:@"ZoomType"  parentElement:data];
    if (zoomType != nil)
    {
        NSString *zoomTypeStr = [EMTBXML textForElement:zoomType];
        if ([zoomTypeStr isEqualToString:@"zoom_inner"])
        {
            self.isZoomInner = YES;
        }
        else
        {
            self.isZoomInner = NO;
        }
    }
    TBXMLElement *imgType = [EMTBXML childElementNamed:@"ImageType"  parentElement:data];
    if (imgType != nil)
    {
        self.type         = [EMTBXML textForElement:imgType];
    }
    else
    {
        self.type         = nil;
    }
    TBXMLElement *imgScale = [EMTBXML childElementNamed:@"ImageScale"  parentElement:data];
    if (imgScale != nil)
    {
        self.scale        = [[EMTBXML textForElement:imgScale] floatValue];
    }
    [pool release];
}

- (void)dealloc
{
    [type release]; type = nil;
    [super dealloc];
}
@end
