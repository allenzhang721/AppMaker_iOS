//
//  HTML5Entity.m
//  MoueeiOS2Framework
//
//  Created by Pi Yi on 4/27/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "HTML5Entity.h"

@implementation HTML5Entity
-(void) decode:(TBXMLElement *)container
{
    TBXMLElement *component  = [EMTBXML childElementNamed:@"Component"  parentElement:container];
    TBXMLElement *data       = [EMTBXML childElementNamed:@"Data"  parentElement:component];
    TBXMLElement *ele = [EMTBXML childElementNamed:@"IndexHtml" parentElement:data];
    if (ele)
    {
        self.indexName = [EMTBXML textForElement:ele];
    }
    ele = [EMTBXML childElementNamed:@"HtmlFolder" parentElement:data];
    if (ele)
    {
        self.folderName = [EMTBXML textForElement:ele];
    }
}

- (void)dealloc
{
    [self.indexName release];
    [self.folderName release];
    [super dealloc];
}
@end
