//
//  PaintComponent.h
//  Core
//
//  Created by user on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Component.h"
#import "PaintingView.h"
#import "PaintViewController.h"

@interface PaintComponent : Component
{
    PaintViewController *controller;
}

@property (nonatomic , retain) PaintViewController *controller;
-(id) initWithPath:(NSString*) path :(GLfloat) width :(GLfloat) height;

-(void)onCloseSnapshots;
@end
