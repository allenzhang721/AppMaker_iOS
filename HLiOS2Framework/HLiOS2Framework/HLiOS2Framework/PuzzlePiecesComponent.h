//
//  PuzzlePiecesComponent.h
//  Core
//
//  Created by user on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Component.h"
#import "PuzzleViewContorller.h"

@interface PuzzlePiecesComponent : Component
{
    PuzzleViewContorller *controller;
}


@property (nonatomic , retain) PuzzleViewContorller *controller;

-(id) initWithPath:(NSString*) path entityID:(NSString *)entityid :(GLfloat) width :(GLfloat) height;

@end
