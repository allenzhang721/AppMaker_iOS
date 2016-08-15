//
//  VerSliderSelectEntity.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-22.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "VerSliderSelectEntity.h"

@implementation VerSliderSelectEntity

- (id)init
{
    self = [super init];
    if (self)
    {
        self.itemArray = [[[NSMutableArray alloc] init] autorelease];
        
    }
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    TBXMLElement *renderImages    = [EMTBXML childElementNamed:@"RenderImages"  parentElement:moduleData];
    TBXMLElement *images    = [EMTBXML childElementNamed:@"Images"  parentElement:renderImages];
    while (images != nil)
    {
        TBXMLElement *itemId = [EMTBXML childElementNamed:@"ID" parentElement:images];
        TBXMLElement *itemWidth = [EMTBXML childElementNamed:@"ItemWidth" parentElement:images];
        TBXMLElement *itemHeight = [EMTBXML childElementNamed:@"ItemHeight" parentElement:images];
        TBXMLElement *sourceID = [EMTBXML childElementNamed:@"SourceID" parentElement:images];
        TBXMLElement *selectedSourceID = [EMTBXML childElementNamed:@"SelectedSourceID" parentElement:images];
        
        NSString *idStr = [EMTBXML textForElement:itemId];
        NSString *widthStr = [EMTBXML textForElement:itemWidth];
        NSString *heightStr = [EMTBXML textForElement:itemHeight];
        NSString *sourceStr = [EMTBXML textForElement:sourceID];
        NSString *selectSourceStr = [EMTBXML textForElement:selectedSourceID];
        
        
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                  idStr, @"ID",
                                  widthStr, @"ItemWidth",
                                  heightStr, @"ItemHeight",
                                  sourceStr, @"SourceID",
                                  selectSourceStr, @"SelectedSourceID",
                                  nil]];
        
        images = [EMTBXML nextSiblingNamed:@"Images" searchFromElement:images];
    }
    
    [pool release];
}

- (void)dealloc
{
    self.itemArray = nil;
    [super dealloc];
}

@end
