//
//  PDFEntity.m
//  Core
//
//  Created by mac on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PDFEntity.h"

@implementation PDFEntity
@synthesize index;

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.fileName = [EMTBXML textForElement:[EMTBXML childElementNamed:@"PDFSourceID" parentElement:data]];
    NSString *pdfIndex       = [EMTBXML textForElement:[EMTBXML childElementNamed:@"PDFPageIndex" parentElement:data]];
    self.index = [pdfIndex intValue];
    [pool release];
}
@end
