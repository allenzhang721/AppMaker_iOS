//
//  SectionEntity.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SectionEntity.h"
#import "PageEntity.h"

@implementation SectionEntity

@synthesize sectionid;
@synthesize pages;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        self.pages = [[NSMutableArray alloc] initWithCapacity:10];
        [self.pages release];
    }
    
    return self;
}

- (void)dealloc 
{
    [self.sectionid release];
    [self.pages removeAllObjects];
    [self.pages release];
    [super dealloc];
}

-(bool) isPageExist:(NSString *) pageid
{
    for (int i = 0 ; i  < [self.pages count];i++)
    {
        NSString* pg = [self.pages objectAtIndex:i];
        if ([pg compare:pageid] == NSOrderedSame)
        {
            return YES;
        }
    }
    return NO;
}

-(PageEntity *) getPageByID:(NSString *) pageid
{
    for (int i = 0 ; i  < [self.pages count];i++)
    {
        NSString* pg = [self.pages objectAtIndex:i];
        if ([pg compare:pageid] == NSOrderedSame)
        {
            return [self.pages objectAtIndex:i];
        }
    }
    return nil;
}

@end
