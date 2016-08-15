//
//  ScrollImage.m
//  Core
//
//  Created by MoueeSoft on 12-12-5.
//
//

#import "ScrollImageEntity.h"

@implementation ScrollImageEntity

@synthesize itemHeight;
@synthesize itemWidth;

- (id)init
{
    self = [super init];
    if (self) {
        self.images = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc
{
    self.images = nil;
    [super dealloc];
}

- (void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    TBXMLElement *sourceID = [EMTBXML childElementNamed:@"SourceID" parentElement:moduleData];
    while (sourceID)
    {
        NSString *imageName = [EMTBXML textForElement:sourceID];
        if (imageName)
        {
            [self.images addObject:imageName];
        }
        sourceID = [EMTBXML nextSiblingNamed:@"SourceID" searchFromElement:sourceID];
    }
    TBXMLElement *we = [EMTBXML childElementNamed:@"ItemWidth" parentElement:moduleData];
    if (we)
    {
        self.itemWidth =  [[EMTBXML textForElement:we] floatValue];
    }
    TBXMLElement *he = [EMTBXML childElementNamed:@"ItemHeight" parentElement:moduleData];
    if (he)
    {
        self.itemHeight =  [[EMTBXML textForElement:he] floatValue];
    }
    [pool release];
}

@end
