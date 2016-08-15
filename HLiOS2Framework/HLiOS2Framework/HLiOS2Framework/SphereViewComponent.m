//
//  SphereViewComponent.m
//  Core
//
//  Created by mac on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SphereViewComponent.h"
#import "SphereView.h"
#import "HLContainer.h"
#import "HLContainerEntity.h"
#import "SphereViewEntity.h"

#define kMaxScale 2.9
#define kMinScale .5

@implementation SphereViewComponent

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self != nil)
    {
        SphereView *sv = [[[SphereView alloc] initWithFrame:CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue])] autorelease];
        sv.isAutoRotation = ((SphereViewEntity*)entity).isAutoRotation;
        sv.isClockWise = ((SphereViewEntity*)entity).isClockWise;
        NSMutableArray *ar = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
        for (int i = 0; i < [((SphereViewEntity*)entity).images count]; i++)
        {
            NSString *imagePath = [((SphereViewEntity*)entity).images objectAtIndex:i];
            imagePath = [[entity.rootPath stringByAppendingPathComponent:entity.dataid] stringByAppendingPathComponent:imagePath];
            //            UIImage *image   = [UIImage imageWithContentsOfFile:imagePath];
            //            UIImageView *imv = [[[UIImageView alloc] initWithImage:image] autorelease];
            //            imv.frame        = CGRectMake(width*i, 0, width, height);
            [ar addObject:imagePath];
        }
        sv.isVertical = ((SphereViewEntity*)entity).isVertical;
        sv.isLoop     = ((SphereViewEntity*)entity).isLoop;
        sv.isAllowZoom= YES;
        //        sv.isLoop = NO;
        [sv setPatharray:ar];
        sv.delegate = self;
        sv.speed = ((SphereViewEntity*)entity).speed;
        self.uicomponent = sv;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
        
        if (((SphereViewEntity*)entity).isAllowZoom)//只有360可以缩放 横竖向滑动序列不可以缩放
        {
            UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)] autorelease];
            //        [pinchRecognizer setDelegate:self];
            [sv addGestureRecognizer:pinchRecognizer];
        }
    }
    return self;
}

- (void)scale:(id)sender
{
    //    NSLog(@"%f",[[self.uicomponent.layer valueForKeyPath: @"transform.scale"] floatValue]);
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan)
    {
        lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    float curScale = [[self.uicomponent.layer valueForKeyPath: @"transform.scale"] floatValue];
    
    scale = MIN(scale, kMaxScale / curScale);
    scale = MAX(scale, kMinScale / curScale);
    
    CGAffineTransform currentTransform = self.uicomponent.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [self.uicomponent setTransform:newTransform];
    
    lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

-(void)didShowPicIndex:(NSInteger)index
{
    //[self retain];
    // [self.container retain];
    
    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
        if ([behavior.behaviorValue intValue] == index && [behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CHANGE_COMPLETE"] == YES)
        {
            if ([self.container runBehaviorWithEntity:behavior])
            {
                return;
            }
        }
    }
    
    //    for (int i = 0; i < count; i++)
    //    {
    //        BehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
    //        NSArray *array  = [behavior.value componentsSeparatedByString:@";"];
    //        if ([array count] > 0 )
    //        {
    //            NSString *n = [array objectAtIndex:0];
    //            if ([n integerValue] == index)
    //            {
    //                if ([array count] > 1)
    //                {
    ////                    [self.container.page runBehavior:behavior.functionObjectID :behavior.functionName : [array objectAtIndex:1]];
    //                }
    //                else
    //                {
    ////                    [self.container.page runBehavior:behavior.functionObjectID :behavior.functionName : nil];
    //                }
    //
    //            }
    //        }
    //    }
    // [self performSelector:@selector(release) withObject:nil afterDelay:0.3f];
    // [self.container performSelector:@selector(release) withObject:nil afterDelay:0.3f];
}

- (void)dealloc
{
    [(SphereView*)self.uicomponent stopTimer];
    ((SphereView*)self.uicomponent).delegate = nil;
    [self.uicomponent removeFromSuperview];     //陈星宇，11.4
	[self.uicomponent release];
    [super dealloc];
}
@end
