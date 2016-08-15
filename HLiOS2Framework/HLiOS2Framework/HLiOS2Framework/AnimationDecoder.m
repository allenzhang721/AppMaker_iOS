//
//  AnimationDecoder.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AnimationDecoder.h"
#import "MovementAnimation.h"
#import "AnimationCreator.h"

@implementation AnimationDecoder

static float sx1 = 1.0;
static float sy1 = 1.0;


+(void) setSX:(float) sx;
{
    sx1 = sx;
}

+(void) setSY:(float) sy
{
    sy1 = sy;
}

+(float) getSX;
{
    return sx1;
}

+(float) getSY;
{
    return sy1;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(Animation*) decode:(TBXMLElement *)animationElement
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *className  = [EMTBXML textForElement:[EMTBXML childElementNamed:@"ClassName" parentElement:animationElement]];
    TBXMLElement *data   = [EMTBXML childElementNamed:@"Data"  parentElement:animationElement];
    Animation *animation;
    if ([className compare:@"com.mouee.flex.core.movement.model::CatmullRomMovePath"] == NSOrderedSame)
    {
        animation = [[MovementAnimation alloc] init];
    }
    else
    {
        NSString *type = [EMTBXML textForElement:[EMTBXML childElementNamed:@"AnimationType" parentElement:data]];
        animation = [AnimationCreator createAnimation:type];
    }
    [animation decode:data];
    [pool release];
    return animation;
}


@end
