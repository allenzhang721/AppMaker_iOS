//
//  ButtonContainerEntity.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-15.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "ButtonContainerEntity.h"

@implementation ButtonContainerEntity

- (id)init
{
    self = [super init];
    if (self)
    {

    }
    
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    TBXMLElement *souceid    = [EMTBXML childElementNamed:@"SourceID"  parentElement:data];
    if (souceid != nil)
    {
        self.upImgName = [EMTBXML textForElement:souceid];
    }
    souceid    = [EMTBXML childElementNamed:@"DownSourceID"  parentElement:data];
    if (souceid != nil)
    {
        self.downImgName = [EMTBXML textForElement:souceid];
    }
    [pool release];
}

-(void)dealloc
{
    [self.downImgName release];
    [self.upImgName release];
    [super dealloc];
}


@end
