//
//  FontSizeSliderEntity.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-6-21.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "FontSizeSliderEntity.h"
#import "RollingTextEntity.h"

@implementation FontSizeSliderEntity

-(id)init
{
    self = [super init];
    if (self)
    {
        self.minFontSize = 12;
        self.maxFontSize = 30;
    }
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement *maxSize = [EMTBXML childElementNamed:@"MaxSize" parentElement:data];
    if (maxSize)
    {
        NSString *value = [EMTBXML textForElement:maxSize];
        if (value)
        {
            self.maxFontSize = [value intValue];
        }
    }
    TBXMLElement *minSize = [EMTBXML childElementNamed:@"MinSize" parentElement:data];
    if (minSize)
    {
        NSString *value = [EMTBXML textForElement:minSize];
        if (value)
        {
            self.minFontSize = [value intValue];
        }
    }
    TBXMLElement *curSize = [EMTBXML childElementNamed:@"CurrentSize" parentElement:data];
    if (curSize)
    {
        NSString *value = [EMTBXML textForElement:curSize];
        if (value)
        {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SStaticFontSize"])
            {
                self.curFontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SStaticFontSize"] intValue];
            }
            else
            {
                self.curFontSize = [value intValue];
            }
        }
    }
    [pool release];
}

-(void)dealloc
{
    
    [super dealloc];
}

@end
