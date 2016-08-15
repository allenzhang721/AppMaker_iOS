//
//  PuzzlePiecesComponent.m
//  Core
//
//  Created by user on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PuzzlePiecesComponent.h"
#import "PuzzlePiecesEntity.h"

@implementation PuzzlePiecesComponent

@synthesize controller;


- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self != nil)
    {
        self.controller = [[PuzzleViewContorller alloc] init];
        [self.controller release];
        self.controller.imagePath =  [entity.rootPath stringByAppendingPathComponent:((PuzzlePiecesEntity*)entity).img];
        self.controller.viewwidth = [entity.width floatValue];
        self.controller.viewheight = [entity.height floatValue];
        self.controller.entityID = entity.entityid;
        self.uicomponent = self.controller.view;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
    }
    return self;
}

-(id) initWithPath:(NSString*) path entityID:(NSString *)entityid :(GLfloat) width :(GLfloat) height
{
    self = [super init];
    if (self) {
        
        NSLog(@"PuzzleViewContorller alloc");
        self.controller = [[PuzzleViewContorller alloc] init];
        [self.controller release];
        self.controller.imagePath = path;
        self.controller.viewwidth = width;
        self.controller.viewheight = height;
        self.controller.entityID = entityid;
        
        self.uicomponent = self.controller.view;
    }
    return self;
}

-(void)stop
{
    [self.controller onComponentStop];
}

- (void)dealloc 
{
    [self.uicomponent removeFromSuperview];     //陈星宇，11.4
    [self.uicomponent release];
    self.controller = nil;
    [super dealloc];
}

@end
