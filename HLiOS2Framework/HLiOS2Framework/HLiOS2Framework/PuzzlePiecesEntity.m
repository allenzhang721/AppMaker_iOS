//
//  PuzzlePiecesEntity.m
//  Core
//
//  Created by user on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PuzzlePiecesEntity.h"

@implementation PuzzlePiecesEntity


@synthesize img;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement *moduleData = [EMTBXML childElementNamed:@"ModuleData"  parentElement:data];
    TBXMLElement *souceid    = [EMTBXML childElementNamed:@"sourceID"  parentElement:moduleData];
    self.img = [EMTBXML textForElement:souceid];
    [pool release];
}

- (void)dealloc
{
    [self.img release];
    [super dealloc];
}
@end
