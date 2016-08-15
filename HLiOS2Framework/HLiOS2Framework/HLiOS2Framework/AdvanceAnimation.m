//
//  AdvanceAnimation.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 4/3/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "AdvanceAnimation.h"
#import "AdvanceAnimationModel.h"
#import "HLNSBKeyframeAnimation.h"


@implementation AdvanceAnimation

@synthesize models;
@synthesize center;
@synthesize x;
@synthesize y;
@synthesize width;
@synthesize height;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.models = [[[NSMutableArray alloc] init] autorelease];
        isFirstTime = YES;
    }
    return self;
}

- (void)timerUpdate
{
    CALayer* layer = self.view.layer.presentationLayer;
    self.view.layer.transform = layer.transform;
    self.view.layer.bounds    = layer.bounds;
    if (!isnan(layer.position.x) && !isnan(layer.position.y))
    {
        self.view.layer.position  = layer.position;
    }
    self.view.layer.opacity   = layer.opacity;
}

-(void) playHandler
{
    //    [self.container onAnimationStart];
    self.startTime = [self.view.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    if (self.models.count <= 1)
    {
        return;
    }
    if (self.isPaused == YES)
    {
        [super playHandler];
        return;
    }
    [super playHandler];
    
    if (isFirstTime)
    {
        self.containerRotation = [(NSNumber *)[self.view.layer valueForKeyPath:@"transform.rotation"] floatValue];
        [self.view.layer setValue:[NSNumber numberWithFloat:0]forKeyPath:@"transform.rotation"];
        
        self.containerRect = self.view.frame;
        self.containerOriginRect = self.view.frame;//added by Adward 13-11-28
        [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation] forKeyPath:@"transform.rotation"];
        self.startLayer = self.view.layer;
        AdvanceAnimationModel *model = [self.models objectAtIndex:0];
        self.center  = self.view.center;
        model.pointx = self.containerRect.origin.x + self.containerRect.size.width / 2;
        model.pointy = self.containerRect.origin.y + self.containerRect.size.height / 2;
        model.objx   = self.containerRect.origin.x;
        model.objy   = self.containerRect.origin.y;
        model.objrotation = self.containerRotation;
        model.objwidth    = self.containerRect.size.width;
        model.objheight   = self.containerRect.size.height;
        model.objalpha    = self.view.layer.opacity;
    }
    
    NSLog(@"adcenter:%@",NSStringFromCGPoint(self.center));
    
    HLNSBKeyframeAnimation *move = [HLNSBKeyframeAnimation animationWithKeyPath:@"position" duration:self.duration startValue:1 endValue:1 function:self.easeFunction];
    
    NSMutableArray *animations = [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableArray *kta = [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:5];
    float currentDuration = 0;
    for (int i = 0 ; i < [self.models count]; i++)
    {
        AdvanceAnimationModel *model = [self.models objectAtIndex:i];
        CGPoint point = CGPointMake(model.pointx, model.pointy);
        
        [points addObject:[NSValue valueWithBytes:& point objCType:@encode(CGPoint)]];
        currentDuration += model.duration/1000;
        float sgt        = currentDuration / self.duration;
        [kta addObject:[NSNumber numberWithFloat:sgt ]];
        if ((i+1)<[self.models count])
        {
            AdvanceAnimationModel *model2 = [self.models objectAtIndex:(i+1)];
            
            float fromValue = model.objrotation* M_PI / 180.0f;
            if (i == 0)
            {
                fromValue = self.containerRotation;;
            }
            float toValue   = model2.objrotation* M_PI / 180.0f;
            HLNSBKeyframeAnimation *rotate = [HLNSBKeyframeAnimation animationWithKeyPath:@"transform.rotation" duration:self.duration startValue:fromValue endValue:toValue function:self.easeFunction];
            [rotate setDuration:model2.duration/1000];
            [rotate setBeginTime: currentDuration];
            
            float fromWidth = model.objwidth;
            float toWidth   = model2.objwidth;
            HLNSBKeyframeAnimation *sizeWidth = [HLNSBKeyframeAnimation animationWithKeyPath:@"bounds.size.width" duration:self.duration startValue:fromWidth endValue:toWidth function:self.easeFunction];
            [sizeWidth setDuration:model2.duration/1000];
            [sizeWidth setBeginTime: currentDuration];
            
            float fromHeight = model.objheight;
            float toHeight   = model2.objheight;
            HLNSBKeyframeAnimation *sizeHeight = [HLNSBKeyframeAnimation animationWithKeyPath:@"bounds.size.height" duration:self.duration startValue:fromHeight endValue:toHeight function:self.easeFunction];
            [sizeHeight setDuration:model2.duration/1000];
            [sizeHeight setBeginTime: currentDuration];
            
            float fromalpha = model.objalpha;
            float toalpha   = model2.objalpha;
            HLNSBKeyframeAnimation *fade = [HLNSBKeyframeAnimation animationWithKeyPath:@"opacity" duration:self.duration startValue:fromalpha endValue:toalpha function:self.easeFunction];
            [fade setDuration:model2.duration/1000];
            [fade setBeginTime: currentDuration];
            
            [animations addObject:fade];
            [animations addObject:rotate];
            [animations addObject:sizeWidth];
            [animations addObject:sizeHeight];
        }
    }
    [move  setKeyTimes:kta];
    [move setValues:points];
    [move setDuration:self.duration];
    [move setFillMode:kCAFillModeForwards];
    move.removedOnCompletion = YES;
    move.calculationMode = kCAAnimationCubic;
    
    [animations addObject:move];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setFillMode:kCAFillModeForwards];
    group.removedOnCompletion =NO;
    group.delegate = self;
    [group setDuration:self.duration];
    [group setAnimations:  animations];
    if (self.times > 0 )
    {
        group.repeatCount = self.times;
    }
    if (self.isLoop == YES)
    {
        group.repeatCount = HUGE_VALF;
    }
    [group setBeginTime:CACurrentMediaTime()];
    [self.view.layer addAnimation:group forKey:@"adAnimation"];
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    }
    [animations release];
    [kta release];
    [points release];
    self.startTime = [self.view.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    isFirstTime = NO;

}

-(void) decode:(TBXMLElement *) data
{
    [super decode:data];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement* animationData =  [EMTBXML childElementNamed:@"AnimationData" parentElement:data];
    if (animationData != nil)
    {
        AdvanceAnimationModel *model = [[[AdvanceAnimationModel alloc] init] autorelease];
        [self.models addObject:model];
        TBXMLElement* animationModels =  [EMTBXML childElementNamed:@"AnimationModels" parentElement:animationData];
        if (animationModels != nil)
        {
            TBXMLElement *animationModel  = [EMTBXML childElementNamed:@"AnimationModel"  parentElement:animationModels];
            while (animationModel != nil)
            {
                AdvanceAnimationModel *model = [[[AdvanceAnimationModel alloc] init] autorelease];
                TBXMLElement *pointx =  [EMTBXML childElementNamed:@"PointX"  parentElement:animationModel];
                TBXMLElement *pointy =  [EMTBXML childElementNamed:@"PointY"  parentElement:animationModel];
                TBXMLElement *dur    =  [EMTBXML childElementNamed:@"Duration"  parentElement:animationModel];
                TBXMLElement *delays  =  [EMTBXML childElementNamed:@"Delay"  parentElement:animationModel];
                TBXMLElement *easetype = [EMTBXML childElementNamed:@"EaseType"  parentElement:animationModel];
                TBXMLElement *objX   = [EMTBXML childElementNamed:@"ObjX"  parentElement:animationModel];
                TBXMLElement *objY   = [EMTBXML childElementNamed:@"ObjY"  parentElement:animationModel];
                TBXMLElement *objWidth     = [EMTBXML childElementNamed:@"ObjWidth"  parentElement:animationModel];
                TBXMLElement *objHeight    = [EMTBXML childElementNamed:@"ObjHeight"  parentElement:animationModel];
                TBXMLElement *objRotation  = [EMTBXML childElementNamed:@"ObjRotation"  parentElement:animationModel];
                TBXMLElement *objAlpha  = [EMTBXML childElementNamed:@"ObjAlpha"  parentElement:animationModel];
                model.pointx         =  [[EMTBXML textForElement:pointx] floatValue];
                model.pointy         =  [[EMTBXML textForElement:pointy] floatValue];
                model.duration       =  [[EMTBXML textForElement:dur] floatValue];
                model.delay          =  [[EMTBXML textForElement:delays] floatValue];
                model.easeType       =  [EMTBXML textForElement:easetype];
                model.objx           =  [[EMTBXML textForElement:objX] floatValue];
                model.objy           =  [[EMTBXML textForElement:objY] floatValue];
                model.objwidth       =  [[EMTBXML textForElement:objWidth] floatValue];
                model.objheight      =  [[EMTBXML textForElement:objHeight] floatValue];
                model.objrotation    =  [[EMTBXML textForElement:objRotation] floatValue];
                model.objalpha       =  [[EMTBXML textForElement:objAlpha] floatValue];
                [self.models addObject:model];
                animationModel = [EMTBXML nextSiblingNamed:@"AnimationModel" searchFromElement:animationModel];
            }
        }
    }
    [pool release];
}

- (void)stop
{
    if(self.isPlaying || self.isPaused)
    {
        if (_timer && [_timer isValid])
        {
            [_timer invalidate];
            _timer = nil;
        }
        AdvanceAnimationModel *model = [self.models objectAtIndex:0];
        
        [self.view.layer setValue:[NSNumber numberWithFloat:model.objrotation] forKeyPath:@"transform.rotation"];
        self.view.layer.bounds = CGRectMake(model.objx, model.objy, model.objwidth, model.objheight);
        self.view.layer.opacity = model.objalpha;
        self.container.component.uicomponent.layer.opacity = model.objalpha;
        self.view.center = self.center;
        
        [self.view.layer removeAllAnimations];
        self.view.layer.speed      = 1.0;
        self.view.layer.timeOffset = 0.0;
        self.view.layer.beginTime  = 0.0;
        self.isPaused = NO;
        self.isPlaying = NO;
        [self reset];
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [super animationDidStop:anim finished:flag];
    if (_timer && [_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)keep
{
    if (self.view.hidden == NO)
    {
        self.container.component.uicomponent.layer.opacity = [self.container.entity.alpha floatValue];
    }
    CALayer* layer = self.view.layer.presentationLayer;
    self.view.layer.transform = layer.transform;
    self.view.layer.bounds    = layer.bounds;
    if (!isnan(layer.position.x) && !isnan(layer.position.y))
    {
        self.view.layer.position  = layer.position;
    }
    self.view.layer.opacity   = layer.opacity;
}

-(void)reset
{
    AdvanceAnimationModel *model = [self.models objectAtIndex:0];
    
    [self.view.layer setValue:[NSNumber numberWithFloat:model.objrotation] forKeyPath:@"transform.rotation"];
    self.view.layer.bounds = CGRectMake(model.objx, model.objy, model.objwidth, model.objheight);
    self.view.layer.opacity = model.objalpha;
    self.container.component.uicomponent.layer.opacity = model.objalpha;
    self.view.center = self.center;
    
    self.view.layer.speed      = 1.0;
    self.view.layer.timeOffset = 0.0;
    self.view.layer.beginTime  = 0.0;
    self.isPaused = NO;
    self.isPlaying = NO;
}


- (void)dealloc
{
    [self.startLayer release];
    [self.models release];
    [super dealloc];
}

@end
