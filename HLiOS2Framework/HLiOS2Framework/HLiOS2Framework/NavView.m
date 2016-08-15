//
//  NavView.m
//  Core
//
//  Created by user on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NavView.h"

@implementation NavView
@synthesize snapshots;
@synthesize snapTitles;
@synthesize rootpath;
@synthesize mode;
@synthesize flipView;
@synthesize isPoped;
@synthesize currentPageIndex;
@synthesize isVertical;
@synthesize allSectionPageId;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) changeToVertical
{
    
}

-(void) changeToHorizontal
{
    
}

-(void) load
{
    
}

-(void) hide
{
    
}

-(void) popup
{
    
}

-(void) popdown
{
    
}

-(void) refresh
{}

-(void)dealloc
{
    self.rootpath = nil;
    self.mode = nil;
    [_snapshotsIndesign release];
    [snapshots removeAllObjects];
    [snapshots release];
    [snapTitles removeAllObjects];
    [snapTitles release];
    [allSectionPageId release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
