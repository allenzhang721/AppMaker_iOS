//
//  ImageSliderEntity.m
//  Core
//
//  Created by mac on 12-3-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageSliderEntity.h"

@implementation ImageSliderEntity

@synthesize images;
@synthesize imageUrls;
@synthesize isVertical;
@synthesize fromUrl;
@synthesize isShowPageControl;
@synthesize imageDesDic;

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.fromUrl = NO;
        self.isVertical = NO;
        self.images = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        self.imageUrls = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        self.imageDesDic = [[[NSMutableDictionary alloc] init] autorelease];
    }
    
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    if (self.fromUrl)
    {
        TBXMLElement *source = [EMTBXML childElementNamed:@"source" parentElement:moduleData];
        while (source != nil)
        {
            TBXMLElement *sourceid = [EMTBXML childElementNamed:@"sourceID" parentElement:source];
            if (sourceid)
            {
                NSString *simg = [EMTBXML textForElement:sourceid];
                [self.images addObject:simg];
            }
            TBXMLElement *sourceUrl = [EMTBXML childElementNamed:@"sourceURL" parentElement:source];
            if (sourceUrl)
            {
                NSString *imageUrl = [EMTBXML textForElement:sourceUrl];
                [self.imageUrls addObject:imageUrl];
            }
            source = [EMTBXML nextSiblingNamed:@"source" searchFromElement:source];
        }
    }
    else
    {
        TBXMLElement *souceid    = [EMTBXML childElementNamed:@"sourceID" parentElement:moduleData];
        while (souceid != nil)
        {
            NSString *simg = [EMTBXML textForElement:souceid];
            [self.images addObject:simg];
            souceid = [EMTBXML nextSiblingNamed:@"sourceID" searchFromElement:souceid];
        }
        TBXMLElement *isShowNavi = [EMTBXML childElementNamed:@"IsShowNavi" parentElement:moduleData];
        if (isShowNavi)
        {
            self.isShowPageControl = [[EMTBXML textForElement:isShowNavi] boolValue];
        }
        TBXMLElement *sourceDes = [EMTBXML childElementNamed:@"SourceDes" parentElement:moduleData];
        if (sourceDes)
        {
            TBXMLElement *render = [EMTBXML childElementNamed:@"Render" parentElement:sourceDes];
            while(render)
            {
                TBXMLElement *renderID = [EMTBXML childElementNamed:@"RenderID" parentElement:render];
                TBXMLElement *renderDes = [EMTBXML childElementNamed:@"RenderDes" parentElement:render];
                NSString *renderIDStr = [EMTBXML textForElement:renderID];
                NSString *renderDesStr = [EMTBXML textForElement:renderDes];
                [imageDesDic setObject:renderDesStr forKey:renderIDStr];
                
                render = [EMTBXML nextSiblingNamed:@"Render" searchFromElement:render];
            }
        }
    }
    [pool release];
}

-(void)dealloc
{
    [imageDesDic release];
    [images release];
    [imageUrls release];
    imageDesDic = nil;
    images      = nil;
    imageUrls   = nil;
    [super dealloc];
}

@end
