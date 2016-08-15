//
//  PhotosResizeEntity.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-30.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "PhotosResizeEntity.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@implementation PhotosResizeEntity

- (id)init
{
    self = [super init];
    if (self)
    {
        self.imageSourceArray = [[[NSMutableArray alloc] init] autorelease];
        self.imgOriSizeArr = [[[NSMutableArray alloc] init] autorelease];
        self.showImgRectArr = [[[NSMutableArray alloc] init] autorelease];
        self.titleArr = [[[NSMutableArray alloc] init] autorelease];
        self.decArr = [[[NSMutableArray alloc] init] autorelease];
        self.audioSourceArr = [[[NSMutableArray alloc] init] autorelease];
        self.zoomArr = [[[NSMutableArray alloc] init] autorelease];
    }
    
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    TBXMLElement *isShowControlPoint = [EMTBXML childElementNamed:@"IsShowControllerPoint"  parentElement:moduleData];
    if (isShowControlPoint)
    {
        self.isShowControllerPoint = [[EMTBXML textForElement:isShowControlPoint] boolValue];
    }
    TBXMLElement *sources = [EMTBXML childElementNamed:@"Sources"  parentElement:moduleData];
    if (sources != nil)
    {
        TBXMLElement *source = [EMTBXML childElementNamed:@"Source" parentElement:sources];
        while (source)
        {
            NSString *sourceID = [EMTBXML textForElement:[EMTBXML childElementNamed:@"ID" parentElement:source]];
            NSString *sourceW = [EMTBXML textForElement:[EMTBXML childElementNamed:@"SourceW" parentElement:source]];
            NSString *sourceH = [EMTBXML textForElement:[EMTBXML childElementNamed:@"SourceH" parentElement:source]];
            NSString *rectX = [EMTBXML textForElement:[EMTBXML childElementNamed:@"RectX" parentElement:source]];
            NSString *rectY = [EMTBXML textForElement:[EMTBXML childElementNamed:@"RectY" parentElement:source]];
            NSString *rectW = [EMTBXML textForElement:[EMTBXML childElementNamed:@"RectW" parentElement:source]];
            NSString *rectH = [EMTBXML textForElement:[EMTBXML childElementNamed:@"RectH" parentElement:source]];
            NSString *title = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Title" parentElement:source]];
            NSString *dec = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Dec" parentElement:source]];
            NSString *isCenterZoom = [EMTBXML textForElement:[EMTBXML childElementNamed:@"IsCenterZoom" parentElement:source]];
            NSString *audioSourceID = [EMTBXML textForElement:[EMTBXML childElementNamed:@"AudioSourceID" parentElement:source]];
            
            [self.imageSourceArray addObject:sourceID];
            [self.imgOriSizeArr addObject:NSStringFromCGSize(CGSizeMake([sourceW floatValue], [sourceH floatValue]))];
            [self.showImgRectArr addObject:NSStringFromCGRect(CGRectMake([rectX floatValue], [rectY floatValue], [rectW floatValue], [rectH floatValue]))];
            [self.titleArr addObject:title];
            [self.decArr addObject:dec];
            [self.audioSourceArr addObject:audioSourceID];
            [self.zoomArr addObject:isCenterZoom];
            
            source = [EMTBXML nextSiblingNamed:@"Source" searchFromElement:source];
        }
    }
    [pool release];
}

-(void)dealloc
{
    [self.audioSourceArr release];
    [self.zoomArr release];
    [self.titleArr release];
    [self.decArr release];
    [self.imageSourceArray release];
    [self.imgOriSizeArr release];
    [self.showImgRectArr release];
    [super dealloc];
}

@end
