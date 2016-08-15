//
//  MoueeCoreTextNode.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-19.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EMTBXML.h"

@interface HLCoreTextNode : NSObject

@property (nonatomic, retain)NSString *text;
@property (nonatomic, retain)UIFont *font;
@property (nonatomic, retain)UIColor *color;
@property (nonatomic, assign)CTTextAlignment alignment;
@property BOOL isUnderLine;

-(void) decodeData:(TBXMLElement *)data;

@end
