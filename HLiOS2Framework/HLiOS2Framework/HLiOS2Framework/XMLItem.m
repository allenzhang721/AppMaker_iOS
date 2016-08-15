//
//  XMLItem.m
//  readXml
//
//  Created by user on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XMLItem.h"

@implementation XMLItem
@synthesize start;
@synthesize end;
@synthesize itemid;

- (void)dealloc 
{
    [self.itemid release];
    [super dealloc];
}
@end
