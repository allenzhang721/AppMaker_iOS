//
//  WebEntity.m
//  MoueeiPad
//
//  Created by mac on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "WebEntity.h"

@implementation WebEntity
@synthesize url;

-(void) decodeData:(TBXMLElement *)data
{
    self.url   = [EMTBXML textForElement:[EMTBXML childElementNamed:@"HtmlUrl" parentElement:data]];
}
@end
