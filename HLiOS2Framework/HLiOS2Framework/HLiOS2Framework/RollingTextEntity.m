//
//  RollingTextEntity.m
//  Core
//
//  Created by Mouee-iMac on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RollingTextEntity.h"

@implementation RollingTextEntity

@synthesize text;
@synthesize fontFamily;
@synthesize showBorder;
@synthesize textColor;
@synthesize backColor;
@synthesize textAlign;

@synthesize enableNote; 
@synthesize backAlpha;
@synthesize fontSize;
@synthesize textNodeArray;

@synthesize borderVisible;
@synthesize borderColor;

-(id)init
{
    self = [super init];
    if (self) 
    {
        self.fontSize = 16;
        self.backAlpha = 0;
        self.textAlign = @"left";
        self.enableNote = NO;
        textNodeArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setStaticFontSize:(int)size
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:size] forKey:@"SStaticFontSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    TBXMLElement * version = [EMTBXML childElementNamed:@"Version" parentElement:data];
    if (version)
    {
        self.isNewTextStyle = [[EMTBXML textForElement:version] intValue] == 0 ? YES : NO;
    }
    else
    {
        self.isNewTextStyle = NO;
    }
    
    TBXMLElement * textElement = [EMTBXML childElementNamed:@"TextContent" parentElement:data];
    if (textElement)
    {
        NSString *content = [EMTBXML textForElement:textElement];
        NSRange range = [content rangeOfString:@"@"];
        if (range.location == 0 && range.length != 0)
        {
            NSString *realContent = [content substringFromIndex:1];
            self.text = realContent;
        }
        else
        {
            self.text = content;
        }
        
    }
    //added by Adward 13-12-12
    TBXMLElement *borderVisibalElement = [EMTBXML childElementNamed:@"borderVisible" parentElement:data];
    if (borderVisibalElement)
    {
        self.borderVisible = [[EMTBXML textForElement:borderVisibalElement] boolValue];
    }
    TBXMLElement *borderVisbalColor = [EMTBXML childElementNamed:@"borderColor" parentElement:data];
    if (borderVisbalColor)
    {
        self.borderColor = [EMTBXML textForElement:borderVisbalColor];
    }
    
    TBXMLElement *noteable = [EMTBXML childElementNamed:@"ViewTextCommentIsShow" parentElement:data];
    if (noteable)
    {
        NSString *value = [EMTBXML textForElement:noteable];
        if (value)
        {
            self.enableNote = [value boolValue];
        }
    }
    
    TBXMLElement *format = [EMTBXML childElementNamed:@"defaultTextLayoutFormat" parentElement:data];
    if (format)
    {
        TBXMLElement *element = [EMTBXML childElementNamed:@"fontFamily" parentElement:format];
        if (element)
        {
            NSString *font = [EMTBXML textForElement:element];
            self.fontFamily = font;
        }
        TBXMLElement *fsize = [EMTBXML childElementNamed:@"fontSize" parentElement:format];
        if (fsize)
        {
            NSString *size = [EMTBXML textForElement:fsize];
            self.fontSize = [size floatValue];
        }
        element = [EMTBXML childElementNamed:@"color" parentElement:format];
        if (element)
        {
            NSString *elem = [EMTBXML textForElement:element];
            self.textColor = elem;
        }
        element = [EMTBXML childElementNamed:@"textAlign" parentElement:format];
        if (element)
        {
            NSString *elem = [EMTBXML textForElement:element];
            self.textAlign = elem;
        }
    }
    
    TBXMLElement *element = [EMTBXML childElementNamed:@"bgcolor" parentElement:data];
    if (element)
    {
        NSString *elem = [EMTBXML textForElement:element];
        self.backColor = elem;
    }
    element = [EMTBXML childElementNamed:@"bgalhpa" parentElement:data];
    if (element)
    {
        NSString *elem = [EMTBXML textForElement:element];
        self.backAlpha = [elem floatValue];
    }
    
    element = [EMTBXML childElementNamed:@"IsStaticText" parentElement:data];
    if (element)
    {
        self.isStatic = [[EMTBXML textForElement:element] boolValue];
        if (self.isStatic)
        {
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SStaticFontSize"])
            {
                self.fontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SStaticFontSize"] intValue];
            }
            else
            {
                [self setStaticFontSize:self.fontSize];
            }
        }
    }
    [pool release];
    
    ///////解析文字xml///////
    EMTBXML* tbxml   = [[[EMTBXML alloc] initWithXMLString:self.text error:nil] autorelease];
    TBXMLElement *root = tbxml.rootXMLElement;
    
    if (root)
	{
        TBXMLElement *p = [EMTBXML childElementNamed:@"p" parentElement:root];
        while (p)
        {
            CTTextAlignment alignment;
            TBXMLElement *span = [EMTBXML childElementNamed:@"span" parentElement:p];
            NSString *textAlignStr = [EMTBXML valueOfAttributeNamed:@"textAlign" forElement:p];
            if ([textAlignStr isEqualToString:@"justify"])
            {
                alignment = kCTTextAlignmentJustified;
            }
            else if ([textAlignStr isEqualToString:@"right"])
            {
                alignment = kCTTextAlignmentRight;
            }
            else if ([textAlignStr isEqualToString:@"center"])
            {
                alignment = kCTTextAlignmentCenter;
            }
            else if ([textAlignStr isEqualToString:@"left"])
            {
                alignment = kCTTextAlignmentLeft;
            }
            while (span)
            {                
                HLCoreTextNode *node = [[[HLCoreTextNode alloc] init] autorelease];
                if (alignment)
                {
                    node.alignment = alignment;
                }
                [node decodeData:span];
                [textNodeArray addObject:node];
                
                span =  [EMTBXML nextSiblingNamed:@"span" searchFromElement:span];
            }
            HLCoreTextNode *node = [[[HLCoreTextNode alloc] init] autorelease];
            [node decodeData:nil];
            [textNodeArray addObject:node];
            
            p =  [EMTBXML nextSiblingNamed:@"p" searchFromElement:p];
        }
    }
}

-(void)dealloc
{
    [textNodeArray release];
    [self.text release];
    [self.fontFamily release];
    [self.backColor release];
    [self.textColor release];
    [self.textAlign release];
    [super dealloc];
}

@end
