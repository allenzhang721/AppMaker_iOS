//
//  PaintComponent.m
//  Core
//
//  Created by user on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PaintComponent.h"
#import "PaintEntity.h"

@implementation PaintComponent
@synthesize controller;

-(id) initWithPath:(NSString*) path :(float) width :(float) height
{
    self = [super init];
    if (self)
    {
        
        self.controller = [[[PaintViewController alloc] init] autorelease];
        self.controller.imagePath = path;
        self.controller.width = width;
        self.controller.height = height;
        self.uicomponent = self.controller.view;
    }
    return self;
}

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self != nil)
    {
        self.controller = [[[PaintViewController alloc] init] autorelease];
        self.controller.imagePath = [entity.rootPath stringByAppendingPathComponent:((PaintEntity*)entity).img];;
        self.controller.width  = [entity.width floatValue];
        self.controller.height = [entity.height floatValue];
        self.controller.entity = (PaintEntity *)entity;//added by Adward 13-12-06
        self.uicomponent = self.controller.view;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
    }
    return self;
}


- (void)dealloc 
{
	//((UIImageView*)self.uicomponent).image = nil;
    // NSLog(@"%d",[self.uicomponent retainCount]);
    // [self.uicomponent removeFromSuperview];
    [self.uicomponent release];
    // NSLog(@"%d",[self.controller retainCount]);
    //[self.controller viewDidUnload];
    self.controller = nil;
    [super dealloc];
}

-(void)onCloseSnapshots
{
    self.controller.view.userInteractionEnabled = YES;
    [self.controller.paintView resetGL];
}
@end