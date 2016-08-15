//
//  PanoramaComponent.m
//  Core
//
//  Created by user on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PanoramaComponent.h"
#import "PanoramaEntity.h"
#import "PLView.h"

@implementation PanoramaComponent


- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self != nil)
    {
        PLView *plView = [[PLView alloc] initWithFrame:CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue])];
        plView.isDeviceOrientationEnabled = NO;
        plView.isAccelerometerEnabled = NO;
        plView.isScrollingEnabled = NO;
        plView.isInertiaEnabled = YES;
        plView.type = PLViewTypeSpherical;
        [plView addTexture:[PLTexture textureWithPath:[entity.rootPath stringByAppendingPathComponent:((PanoramaEntity*)entity).img]]];
        self.uicomponent = plView;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
        [plView release];
    }
    return self;
}


- (void)dealloc 
{
    self.container = nil;
    [self.uicomponent removeFromSuperview];     //陈星宇，11.4
    [self.uicomponent release];
    [super dealloc];
}
@end