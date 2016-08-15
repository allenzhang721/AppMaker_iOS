//
//  SphereViewComponent.h
//  Core
//
//  Created by mac on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Component.h"
#import "SphereView.h"

@interface SphereViewComponent : Component <SphereViewDelegate>
{
    float lastScale;
    BOOL canScale;
}

//-(id) initWithPath: (NSMutableArray*) images :(NSString*) path:(float) width:(float) height :(Boolean)loop :(Boolean)vertical;
@end
