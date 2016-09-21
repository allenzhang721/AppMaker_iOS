//
//  TextInputEntity.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 21/09/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLTextInputEntity.h"

@implementation HLTextInputEntity

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.placeholder = @"";
        self.fontSize = 14;
        self.fontColor = @"000000";
        self.alignment = NSTextAlignmentLeft;
        self.bordVisible = true;
    }
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    /*
     <placeHolder/>
    <fontSize>14</fontSize>
    <fontColor>0x000000</fontColor>
    <fontAlig>0x000000</fontAlig>
    <bordVisible>true</bordVisible>
     */
    
    TBXMLElement *placeHolder = [EMTBXML childElementNamed:@"placeHolder" parentElement:data];
    if (placeHolder) {
        self.placeholder = [EMTBXML textForElement:placeHolder];
    }
    
    TBXMLElement *fontSize = [EMTBXML childElementNamed:@"fontSize" parentElement:data];
    if (fontSize) {
        self.fontSize = [[EMTBXML textForElement:fontSize] floatValue];
    }
    
    TBXMLElement *fontColor = [EMTBXML childElementNamed:@"fontColor" parentElement:data];
    if (fontColor) {
        self.fontColor = [EMTBXML textForElement:fontColor];
    }
    
    TBXMLElement *fontAlig = [EMTBXML childElementNamed:@"fontAlig" parentElement:data];
    if (fontAlig) {
        NSString *alignent = [EMTBXML textForElement:fontAlig];
        if ([alignent  isEqual: @"Left"]) {
            self.alignment = NSTextAlignmentLeft;
        } else {
            self.alignment = NSTextAlignmentLeft;
        }
    }
    
    TBXMLElement *bordVisible = [EMTBXML childElementNamed:@"bordVisible" parentElement:data];
    if (fontSize) {
        self.bordVisible = [[EMTBXML textForElement:bordVisible] boolValue];
    }
    
    [pool release];
}

@end
