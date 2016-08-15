//
//  Container.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//


#import "HLContainer.h"
#import "HLPageController.h"
#import "CaseComponent.h"
#import "ImageComponent.h"
#import "HLLinkageEntity.h"
#import "HLScrollView.h"
#import "RotateMoveInAnimation.h"
#import "ScaleAnimation.h"
#import "WipeAnimation.h"

#define kMaxScale 2.5
#define kMinScale 1
@implementation HLContainer


@synthesize component;

@synthesize entity;
@synthesize autoplayFlag;
@synthesize isMediaPlayCounterAdded;
@synthesize isAnimationCounterAdded;
@synthesize inSpotContainers;
@synthesize isCleaned;
@synthesize behaviorController;
@synthesize pageController;
@synthesize animationPlayIndex;
@synthesize totalAnimationPlayIndex;
@synthesize isGroupPlay;
@synthesize componetRect;
@synthesize comStartPoint;  //陈星宇，11.11
@synthesize isSpotTrigger;
@synthesize isPlayAnimationAtBegining;
@synthesize isSinglePlay;
@synthesize caseIdArray;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        self.caseIdArray = [[[NSMutableArray alloc] init] autorelease];
        self.inSpotContainers = [[[NSMutableArray alloc] init] autorelease];
        self.isCleaned        = NO;
        self.isAnimationCounterAdded = NO;
        self.autoplayFlag     = NO;
        self.isGroupPlay      = NO;
        self.isMediaPlayCounterAdded    = NO;
        self.isAnimationCounterAdded    = NO;
        self.isSpotTrigger    = NO;
        self.animationPlayIndex = 0;
        self.isPlayAnimationAtBegining = NO;
        isPlayingAnimationCount = 0;
        lastImageRate = 1.0;
    }
    return self;
}


-(void) setX:(float)x
{
	[self setAnchorPoint];
	if (self.component.uicomponent != nil)
    {
		self.component.uicomponent.layer.position = CGPointMake(x,self.component.uicomponent.layer.position.y);
	}
}

-(void) setY:(float)y
{
	[self setAnchorPoint];
	if (self.component.uicomponent != nil)
    {
		self.component.uicomponent.layer.position = CGPointMake(self.component.uicomponent.layer.position.x,y);
	}
}

//Added by Adward 13-10-30
-(void) setXChange:(float)x
{
    //	[self setAnchorPointCenter];
	if (self.component.uicomponent != nil)
    {
        //		self.component.uicomponent.layer.position = CGPointMake(x,self.component.uicomponent.layer.position.y);
        self.component.uicomponent.center = CGPointMake(x, self.component.uicomponent.center.y);
	}
}
//Added by Adward 13-10-30
-(void) setYChange:(float)y
{
    //	[self setAnchorPointCenter];
	if (self.component.uicomponent != nil)
    {
        //		self.component.uicomponent.layer.position = CGPointMake(self.component.uicomponent.layer.position.x,y);
        self.component.uicomponent.center = CGPointMake(self.component.uicomponent.center.x, y);
	}
}

-(void) setWidth:(float) width
{
	[self setAnchorPoint];
	if (self.component.uicomponent != nil)
    {
		CGRect rect						 = self.component.uicomponent.layer.frame;
		rect.size.width					 = width;
		self.component.uicomponent.layer.frame = rect;
	}
}

-(void) setHeight:(float) height
{
	[self setAnchorPoint];
	if (self.component.uicomponent != nil)
    {
		CGRect rect							   = self.component.uicomponent.layer.frame;
        rect.size.height					 = height;
		self.component.uicomponent.layer.frame = rect;
	}
}

-(void) setRotation:(float)rotation
{
	[self setAnchorPoint];
	if (self.component.uicomponent != nil)
    {
		[self.component.uicomponent.layer setValue:[NSNumber numberWithFloat:(rotation*M_PI / 180.0f)] forKeyPath:@"transform.rotation"];
	}
}

-(void) setAnchorPointCenter
{
	if (self.component.uicomponent != nil)
    {
		self.component.uicomponent.layer.anchorPoint = CGPointMake(0.5, 0.5);
	}
}

-(void) setAnchorPoint
{
	if (self.component.uicomponent != nil)
    {
		self.component.uicomponent.layer.anchorPoint = CGPointMake(0.0, 0.0);
	}
}

-(void) resetAnchorPoint:(float) rotation
{
    self.component.uicomponent.layer.anchorPoint = CGPointMake(0.5, 0.5);
	float width  = self.component.uicomponent.layer.bounds.size.width/2;
	float height = self.component.uicomponent.layer.bounds.size.height/2;
	float dx = -width *cos(rotation*M_PI / 180.0f) + height*sin(rotation*M_PI / 180.0f);
	float dy = -height*cos(rotation*M_PI / 180.0f) - width *sin(rotation*M_PI / 180.0f);
	self.component.uicomponent.layer.position = CGPointMake(self.component.uicomponent.layer.position.x - dx, self.component.uicomponent.layer.position.y-dy);
}


-(void) addVideoPlayCounter
{
    if (self.isMediaPlayCounterAdded == NO)
    {
        [self.pageController addCounter:self];
        self.isMediaPlayCounterAdded = YES;
    }
}

-(void) delVideoPlayCounter
{
    if (self.isMediaPlayCounterAdded == YES)
    {
        [self.pageController delCounter:self];
        self.isMediaPlayCounterAdded = NO;
    }
}

-(void) addAnimationPlayCounter
{
    if (self.isAnimationCounterAdded == NO)
    {
        [self.pageController addCounter:self];
        self.isAnimationCounterAdded = YES;
    }
}
-(void) delAnimationPlayCounter
{
    if (self.isAnimationCounterAdded == YES)
    {
        [self.pageController delCounter:self];
        self.isAnimationCounterAdded = NO;
    }
}

-(BOOL) runBehavior:(NSString *) eventName index:(int)index
{
    if (self.isCleaned == YES)
    {
        return YES;
    }
    HLBehaviorEntity *behavior = [self.entity.behaviors objectAtIndex:index];
    //    NSString *functionName = [NSString stringWithString:behavior.functionName];
    
    BOOL value = NO;
    
    
    if ([eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CLICK"] ||
        [eventName isEqualToString:@"BEHAVIOR_ON_COUNTER_NUMBER"] ||
        [eventName isEqualToString:@"BEHAVIOR_ON_ANIMATION_END_AT"]||
        [eventName isEqualToString:@"BEHAVIOR_ON_ANIMATION_PLAY_AT"])
    {
        if ([self.behaviorController runBehavior:self.entity.entityid entity:behavior])
        {
            value =  YES;
        }
    }
    return value;
}

-(Boolean) runBehaviorWithEntity:(HLBehaviorEntity *)behavior
{
    if (self.isCleaned == YES)
    {
        return YES;
    }
    Boolean value = NO;
    if ([self.behaviorController runBehavior:self.entity.entityid entity:behavior])
    {
        value = YES;
    }
    return value;
}
-(BOOL) runBehavior:(NSString *) eventName
{
    if (self.isCleaned == YES)
    {
        return YES;
    }
    Boolean ret = NO;
    Boolean isTrigger = NO;
    Boolean isTriigerOnTap = YES;
//    if (self.entity.behaviors.count == 0 && self.componetRect.size.width == 0 && self.componetRect.size.height == 0)    //陈星宇，11，11
//        if (self.entity.behaviors.count == 0) //修复回置问题
//    {
//        [self getComStartPoint];
//    }
    for (int i = 0; i < [self.entity.behaviors count]; i++)
    {
        
        HLBehaviorEntity *behavior = [self.entity.behaviors objectAtIndex:i];
        
        NSString *functionName = [NSString stringWithString:behavior.functionName];
        
        if ([eventName isEqualToString:@"BEHAVIOR_ON_ENTER_SPOT"]&&[behavior.eventName isEqualToString:@"BEHAVIOR_ON_ENTER_SPOT"])
        {
            Boolean hasOutEvent = NO;
            
            if([self checkEnterSpot:behavior])
            {
                [self getComStartPoint];
                
                ret = [self.behaviorController runBehavior:self.entity.entityid entity:behavior];
                self.isSpotTrigger = YES;
            }
            for (int i = 0; i < [self.entity.behaviors count]; i++)
            {
                HLBehaviorEntity *behavior = [self.entity.behaviors objectAtIndex:i];
                if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_OUT_SPOT"])
                {
                    hasOutEvent = YES;
                }
            }
            if (!hasOutEvent)//adward 2.10 有移进热区没有移出热区时
            {
                [self.inSpotContainers removeAllObjects];
            }
        }
        else if (([eventName isEqualToString:@"BEHAVIOR_ON_OUT_SPOT"])&&[behavior.eventName isEqualToString:@"BEHAVIOR_ON_OUT_SPOT"])
        {
            if([self checkOutSpot:behavior])
            {
                [self getComStartPoint];
                ret = [self.behaviorController runBehavior:self.entity.entityid entity:behavior];
                self.isSpotTrigger = YES;
            }
        }
        else if ([behavior.eventName compare:eventName] == NSOrderedSame)
        {
            if([eventName isEqualToString:@"BEHAVIOR_ON_MOUSE_UP"])
            {
                isTriigerOnTap = NO;
            }
            isTrigger = YES;
            ret = [self.behaviorController runBehavior:self.entity.entityid entity:behavior];
        }
        if (ret && ([functionName isEqualToString:@"FUNCTION_PAGE_CHANGE"] ||
                    [functionName isEqualToString:@"FUNCTION_GOTO_PAGE"] ||
                    [functionName isEqualToString:@"FUNCTION_BACK_LASTPAGE"] ||
                    [functionName isEqualToString:@"FUNCTION_GOTO_LASETPAGE"] ||
                    isCleaned))
        {
            if ([UIAccelerometer sharedAccelerometer].delegate)
                
                [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
            return YES;
        }
    }
    if (([eventName isEqualToString:@"BEHAVIOR_ON_MOUSE_UP"]) && (isTrigger == NO))
    {
        if (isTriigerOnTap == YES)
        {
            if (!self.entity.behaviors || self.entity.behaviors.count == 0) {
                [self.pageController onTap];
            }
        }
    }
    return NO;
}

-(void) setSpotInContainer
{
    [self getComStartPoint];
    CGRect refrect       = self.component.uicomponent.frame;
    
    for (int i = 0; i < [self.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.entity.behaviors objectAtIndex:i];
        
        if (([behavior.eventName compare:@"BEHAVIOR_ON_OUT_SPOT"] == NSOrderedSame) || ([behavior.eventName compare:@"BEHAVIOR_ON_ENTER_SPOT"] == NSOrderedSame))
        {
            HLContainer *ref = [self.pageController getContainerByID:behavior.behaviorValue];//热区
            if (ref != nil)
            {
                CGPoint p1 = CGPointMake(refrect.origin.x, refrect.origin.y);
                CGPoint p2 = CGPointMake(refrect.origin.x+refrect.size.width, refrect.origin.y);
                CGPoint p3 = CGPointMake(refrect.origin.x, refrect.origin.y+refrect.size.height);
                CGPoint p4 = CGPointMake(refrect.origin.x+refrect.size.width, refrect.origin.y+refrect.size.height);
                
                if(!CGRectContainsPoint(ref.component.uicomponent.frame, p1))
                {
                    continue;
                }
                if(!CGRectContainsPoint(ref.component.uicomponent.frame, p2))
                {
                    continue;
                }
                if(!CGRectContainsPoint(ref.component.uicomponent.frame, p3))
                {
                    continue;
                }
                if(!CGRectContainsPoint(ref.component.uicomponent.frame, p4))
                {
                    continue;
                }
                if (![self.inSpotContainers containsObject:ref])//避免重复加入
                {
                    //                    NSLog(@"add ref");
                    [self.inSpotContainers addObject:ref];
                }
            }
        }
    }
}

-(BOOL) checkEnterSpot:(HLBehaviorEntity *)behavior
{
    CGRect refrect       = self.component.uicomponent.frame;
    //    [self.inSpotContainers removeAllObjects];
    HLContainer *ref = [self.pageController getContainerByID:behavior.behaviorValue];//热点区域
    //    NSLog(@"inSpotContainers_enterSpot:%@",self.inSpotContainers);
    if (!ref.component.uicomponent.hidden && ref != nil && ![self.inSpotContainers containsObject:ref])//如果热区未隐藏进入，出去触发动作
    {
        CGPoint p1 = CGPointMake(refrect.origin.x, refrect.origin.y);
        CGPoint p2 = CGPointMake(refrect.origin.x+refrect.size.width, refrect.origin.y);
        CGPoint p3 = CGPointMake(refrect.origin.x, refrect.origin.y+refrect.size.height);
        CGPoint p4 = CGPointMake(refrect.origin.x+refrect.size.width, refrect.origin.y+refrect.size.height);
        if(!CGRectContainsPoint(ref.component.uicomponent.frame, p1))
        {
            return NO;
        }
        if(!CGRectContainsPoint(ref.component.uicomponent.frame, p2))
        {
            return NO;
        }
        if(!CGRectContainsPoint(ref.component.uicomponent.frame, p3))
        {
            return NO;
        }
        if(!CGRectContainsPoint(ref.component.uicomponent.frame, p4))
        {
            return NO;
        }
        return YES;
    }
    return NO;
}

-(BOOL) checkOutSpot:(HLBehaviorEntity *)behavior
{
    CGRect refrect       = self.component.uicomponent.frame;
    
    HLContainer *ref = [self.pageController getContainerByID:behavior.behaviorValue];//热点区域
    //    NSLog(@"inSpotContainers_outSpot:%@",self.inSpotContainers);
    if (!ref.component.uicomponent.hidden && ref != nil && [self.inSpotContainers containsObject:ref])
    {
        CGPoint p1 = CGPointMake(refrect.origin.x, refrect.origin.y);
        CGPoint p2 = CGPointMake(refrect.origin.x+refrect.size.width, refrect.origin.y);
        CGPoint p3 = CGPointMake(refrect.origin.x, refrect.origin.y+refrect.size.height);
        CGPoint p4 = CGPointMake(refrect.origin.x+refrect.size.width, refrect.origin.y+refrect.size.height);
        
        if([ref.component.uicomponent.layer hitTest:p1] != nil)
        {
            return NO;
        }
        if([ref.component.uicomponent.layer hitTest:p2] != nil)
        {
            return NO;
        }
        if([ref.component.uicomponent.layer hitTest:p3] != nil)
        {
            return NO;
        }
        if([ref.component.uicomponent.layer hitTest:p4] != nil)
        {
            return NO;
        }
        [self.inSpotContainers removeAllObjects];//adward 1.23
        return YES;
    }
    return NO;
}

//-(void) reset
//{
//    if (self.component != nil)
//    {
//        [self setRotation:[self.entity.rotation floatValue]];
//        [self resetAnchorPoint:[self.entity.rotation floatValue]];
//        [self setX:[self.entity.x floatValue]];
//        [self setY:[self.entity.y floatValue]];
//        [self setWidth:[self.entity.width floatValue]];
//        [self setHeight:[self.entity.height floatValue]];
//        self.component.uicomponent.layer.opacity = [self.entity.alpha floatValue];
//
//    }
//}

-(void) beginView
{
    self.isPlayAnimationAtBegining  = self.entity.isPlayAnimationAtBegining;
    [self.component beginView];
}

-(void) playAll
{
    [self.component playAll];
}

-(void) stopView
{
    for (int i = 0 ; i < [self.entity.animations count]; i++)
    {
        Animation *animation = [self.entity.animations objectAtIndex:i];
        
        // >>>>> Mr.chen , 文字擦除 , 2.22
        if ([animation isKindOfClass:[WipeAnimation class]] && [self.component isKindOfClass:[ImageComponent class]] && ((ImageComponent *)self.component).im.type != nil)
        {
            animation.view      = ((ImageComponent *)self.component).imv;
        }
        else
        {
            animation.view       = self.component.uicomponent;
        }
        // <<<<<
        animation.container  = self;
        [animation stop];
        animation.view       = nil;
        animation.container  = nil;
    }
    self.entity.isPlayAnimationAtBegining    = self.entity.isPlayCacheAnimationAtBegining;
    self.entity.isPlayAudioOrVideoAtBegining = self.entity.isPlayCacheAudioOrVideoAtBegining;
    self.component.neeedCallStop = NO;
    [self.component stop];
}

-(void) runCaseComponent:(NSString *) eventName
{
    if ([eventName isEqualToString:@"FUNCTION_PLAY_VIDEO_AUDIO"]) {
        if (self.caseIdArray.count > 0)
        {
            for (int i = 0; i < self.pageController.objects.count; i++)
            {
                HLContainer *container = [self.pageController.objects objectAtIndex:i];
                if ([self.caseIdArray containsObject:container.entity.entityid])
                {
                    [((CaseComponent *)container.component) runCase:self.pageController];
                }
            }
        }
    }
}

-(void) play
{
    [self delVideoPlayCounter];
    
    [self.component play];
}

-(void) stop
{
    [self.component stop];
    [self delVideoPlayCounter];
}

-(void) pause
{
    [self.component pause];
    [self delVideoPlayCounter];
}

//added by Adward

/**
 *  Get the start Point if the component is boundback
 */
-(void)getComStartPoint
{
    self.comStartPoint = self.component.uicomponent.center;
//    NSLog(@"OntouchBegin = %@",NSStringFromCGPoint(self.comStartPoint));
    if(self.entity.beLinkageArray.count !=0)
    {
        for(int i =0; i<self.entity.beLinkageArray.count;i++)
        {
            HLLinkageEntity *linkEntity = [self.entity.beLinkageArray objectAtIndex:i];
            NSString * linkID = linkEntity.linkID;
            HLContainer *linkContainer =  [self.pageController getContainerByID:linkID];
            linkContainer.comStartPoint = linkContainer.component.uicomponent.center;
            [linkContainer getComStartPoint];
        }
    }
    
}

/**
 *  返回的动作
 */
-(void) bounceBack
{
    [UIView beginAnimations:@"MoveBack" context:nil];
    [UIView setAnimationDuration:0.50];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    NSLog(@"BounceBackTragetPoint = %@",NSStringFromCGPoint(self.comStartPoint));
    
    self.component.uicomponent.center = self.comStartPoint;
    
//    NSLog(@"ontouchend.center = %@",NSStringFromCGPoint(self.component.uicomponent.center));
    
    if(self.entity.beLinkageArray.count !=0)
    {
        for(int i =0; i<self.entity.beLinkageArray.count;i++)
        {
            HLLinkageEntity *linkEntity = [self.entity.beLinkageArray objectAtIndex:i];
            NSString * linkID = linkEntity.linkID;
            HLContainer *linkContainer =  [self.pageController getContainerByID:linkID];
            linkContainer.component.uicomponent.center = linkContainer.comStartPoint;
            [linkContainer bounceBack];
        }
    }
    
    [UIView commitAnimations];
    
//    NSLog(@"finalPoint = %@",NSStringFromCGPoint(self.component.uicomponent.center));
}


-(void) show
{
    if (component.uicomponent.hidden == YES)//adward 2.24保护
    {
        component.uicomponent.hidden = NO;
        component.hidden = NO;
        [component show];
        [self onShow];
    }
}

-(void) hide
{
    if (component.uicomponent.hidden == NO)//adward 2.24保护
    {
        component.uicomponent.hidden = YES;
        component.hidden = YES;
        [component hide];
        [self onHidde];
    }
}


- (void)playSingleAnimation:(int)index
{
    if ([self.entity.animations count] == 0)
    {
        return;
    }
    self.isSinglePlay = YES;
    BOOL isPaused = NO;
    if(self.animationPlayIndex < self.entity.animations.count)
    {
        Animation *an = [self.entity.animations objectAtIndex:self.animationPlayIndex];
        isPaused = an.isPaused;
    }
    if (isPaused && self.animationPlayIndex == index)
    {
        [self playAnimationAtIndex:self.animationPlayIndex isLoop:NO isReset:YES];
    }
    else
    {
        [self playAnimationAtIndex:index isLoop:NO isReset:YES];
    }
}

-(void) playAnimation:(BOOL)isReset
{
    [self.component show];
    if ([self.entity.animations count] == 0)
    {
        return;
    }
    self.isSinglePlay = NO;
    Boolean isAnimationLoop = NO;
    BOOL isPaused = NO;
    if(self.animationPlayIndex < self.entity.animations.count)
    {
        Animation *an = [self.entity.animations objectAtIndex:self.animationPlayIndex];
        isPaused = an.isPaused;
    }
    if (isPaused)
    {
        [self playAnimationAtIndex:self.animationPlayIndex isLoop:YES isReset:isReset];
    }
    else
    {
        self.totalAnimationPlayIndex = 0;
        for (int i = 0 ; i < [self.entity.animations count]; i++)
        {
            Animation *animation = [self.entity.animations objectAtIndex:i];
            if (animation.isLoop == YES)
            {
                isAnimationLoop = YES;
                break;
            }
        }
        if ([self.entity.animations count] > 0)
        {
            [self delAnimationPlayCounter];
            if(self.entity.isPlayAnimationAtBegining == YES)
            {
                if(isAnimationLoop == NO)
                {
                    [self addAnimationPlayCounter];
                }
                self.entity.isPlayAnimationAtBegining = NO;
            }
            else
            {
                if (self.isGroupPlay == YES)
                {
                    if (isAnimationLoop == NO)
                    {
                        [self addAnimationPlayCounter];
                    }
                }
            }
            [self playAnimationAtIndex:0 isLoop:YES isReset:isReset];
        }
    }
}

-(void) playAnimationAtIndex:(int)index isLoop:(BOOL)isLoop isReset:(BOOL)isReset
{
    [self.component show];
    if (index < 0 || self.entity.animations.count == 0)
    {
        return;
    }
    if(index < self.entity.animations.count)
    {
        if(self.animationPlayIndex != index && self.animationPlayIndex < self.entity.animations.count)
        {
            Animation *am = [self.entity.animations objectAtIndex:self.animationPlayIndex];
            if(am.isPlaying)
            {
                [am stop];
            }
        }
        self.animationPlayIndex = index;
        Animation *animation = [self.entity.animations objectAtIndex:self.animationPlayIndex];
        // >>>>> Mr.chen , 文字擦除 , 2.22  
        if ([animation isKindOfClass:[WipeAnimation class]] && [self.component isKindOfClass:[ImageComponent class]] && ((ImageComponent *)self.component).im.type != nil)
        {
            if (animation.view != ((ImageComponent *)self.component).imv) {
                
                animation.view = ((ImageComponent *)self.component).imv;
            }
        }
        else
        {
            if (animation.view != self.component.uicomponent)
            {
                animation.view = self.component.uicomponent;    //Mr.chen , 2.22 , 动画播放
            }
        }
        // <<<<<
        animation.container = self;
        if (animation.isPaused == NO)
        {
            [animation.view.layer removeAllAnimations];
        }
        [animation play];
    }
    else
    {
        if(isReset)
        {
            isPlayingAnimationCount = 0;
        }
        if(isLoop)
        {
            isPlayingAnimationCount++;
            if (self.entity.repeatCount == 0)
            {
                [self playAnimation:NO];
            }
            else if(isPlayingAnimationCount < self.entity.repeatCount)
            {
                [self playAnimation:NO];
            }
            else
            {
                isPlayingAnimationCount = 0;
            }
        }
    }
}

-(void) pauseAnimation
{
    if(self.animationPlayIndex < self.entity.animations.count)
    {
        Animation *animation = [self.entity.animations objectAtIndex:self.animationPlayIndex];
        if(animation.isPlaying)
        {
            // >>>>> Mr.chen , 文字擦除 , 2.22
            if ([animation isKindOfClass:[WipeAnimation class]] && [self.component isKindOfClass:[ImageComponent class]] && ((ImageComponent *)self.component).im.type != nil)
            {
                if (animation.view != ((ImageComponent *)self.component).imv) {
                    
                    animation.view = ((ImageComponent *)self.component).imv;
                }
            }
            else
            {
                if (animation.view != self.component.uicomponent)
                {
                    animation.view = self.component.uicomponent;    //Mr.chen , 2.22 , 动画播放
                }
            }
            // <<<<<
            animation.container = self;
            [animation pause];
        }
    }
}

-(void) stopAnimation
{
    if(self.animationPlayIndex < self.entity.animations.count)
    {
        Animation *animation = [self.entity.animations objectAtIndex:self.animationPlayIndex];
        [animation stop];
    }
    [self delAnimationPlayCounter];
}

-(void) onPlay
{
    [self runBehavior:@"BEHAVIRO_ON_AUDIO_VIDEO_PLAY"];
    if (self.entity.isPlayAudioOrVideoAtBegining == YES)
    {
        if (self.entity.isLoopPlay == NO)
        {
            [self addVideoPlayCounter];
        }
        self.entity.isPlayAudioOrVideoAtBegining = NO;
    }
    else
    {
        if (self.isGroupPlay == YES)
        {
            if (self.entity.isLoopPlay == NO)
            {
                [self addVideoPlayCounter];
            }
        }
    }
}

-(void) onPlayEnd
{
    [self delVideoPlayCounter];
    [self runBehavior:@"BEHAVIOR_ON_AUDIO_VIDEO_END"];
}

-(void) onAnimationStart
{
    if([self runBehavior:@"BEHAVIOR_ON_ANIMATION_PLAY"])
    {
        return;
    }
    int index = self.animationPlayIndex;
    for(int i = 0; i < [self.entity.behaviors count];i++)
    {
        HLBehaviorEntity *behaviorEntity = [self.entity.behaviors objectAtIndex:i];
        if ([behaviorEntity.behaviorValue intValue] == index && [behaviorEntity.eventName isEqualToString:@"BEHAVIOR_ON_ANIMATION_PLAY_AT"])
        {
            if([self runBehavior:@"BEHAVIOR_ON_ANIMATION_PLAY_AT" index:i])
            {
                return;
            }
        }
    }
    
}


-(void) onAnimationEnd
{
    int index = self.animationPlayIndex;
    for(int i = 0; i < [self.entity.behaviors count];i++)
    {
        HLBehaviorEntity *behaviorEntity = [self.entity.behaviors objectAtIndex:i];
        if ([behaviorEntity.behaviorValue intValue] == index && [behaviorEntity.eventName isEqualToString:@"BEHAVIOR_ON_ANIMATION_END_AT"])
        {
            if ([self runBehavior:@"BEHAVIOR_ON_ANIMATION_END_AT" index:i])
            {
                return;
            }
        }
    }
    if ((self.animationPlayIndex + 1) == [self.entity.animations count])
    {
        if ([self runBehavior:@"BEHAVIOR_ON_ANIMATION_END"])
        {
            return;
        }
    }
    if(!self.isSinglePlay)
    {
        if ((self.animationPlayIndex + 1) == [self.entity.animations count] && !self.isSinglePlay)
        {
            [self delAnimationPlayCounter];
        }
        if (self.animationPlayIndex < self.entity.animations.count - 1)
        {
            self.animationPlayIndex++;
            [self playAnimationAtIndex:self.animationPlayIndex isLoop:YES isReset:NO];
        }
        else
        {
            self.totalAnimationPlayIndex ++;
            if (self.entity.repeatCount == 0)
            {
                self.animationPlayIndex = 0;
                [self playAnimationAtIndex:self.animationPlayIndex isLoop:YES isReset:NO];
            }
            else
            {
                if(self.totalAnimationPlayIndex < self.entity.repeatCount)
                {
                    self.animationPlayIndex = 0;
                    [self playAnimationAtIndex:self.animationPlayIndex isLoop:YES isReset:NO];
                }
            }
        }
    }
}

-(void) onShow
{
    [self runBehavior:@"BEHAVIOR_ON_SHOW"];
}

-(void) onHidde
{
    [self runBehavior:@"BEHAVIOR_ON_HIDE"];
}

-(void)change:(int)index
{
    [self.component change:index];
}

//added by Adward
-(void)runLinkageContainerXY:(float)lx :(float)ly
{
    if(self.entity.beLinkageArray.count > 0)
    {
        //        NSLog(@"%@",self.entity.beLinkageArray);
        for(int i = 0; i < self.entity.beLinkageArray.count ; i++)
        {
            HLLinkageEntity *linkEntity = [self.entity.beLinkageArray objectAtIndex:i];
            NSString * linkID = linkEntity.linkID;
            float rate = linkEntity.rate;
            HLContainer *linkContainer =  [self.pageController getContainerByID:linkID];
            //            [linkContainer setAnchorPointCenter];
            float xChange = linkContainer.component.uicomponent.center.x + lx * rate;
            float yChange = linkContainer.component.uicomponent.center.y + ly * rate;
            [linkContainer setXChange:xChange];
            [linkContainer setYChange:yChange];
            [linkContainer runLinkageContainerXY:(lx * rate) :(ly * rate)];
        }
    }
    
}

//Added by Adward 13-10-28 联动图片动画 放大
-(void)runLinkageContainerWidth:(float)wchange Height :(float)hchange
{
    if(self.entity.beLinkageArray.count !=0)
    {
        for(int i =0; i<self.entity.beLinkageArray.count;i++)
        {
            HLLinkageEntity *linkEntity = [self.entity.beLinkageArray objectAtIndex:i];
            NSString * linkID = linkEntity.linkID;
            float rate = linkEntity.rate;
            HLContainer *linkContainer =  [self.pageController getContainerByID:linkID];
            
            float scale = 0.05;
            if (wchange > 0)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    
                    linkContainer.component.uicomponent.transform = CGAffineTransformScale(linkContainer.component.uicomponent.transform, 1+ scale, 1+scale);
                }];
                
            }
            else
            {
                [UIView animateWithDuration:0.5 animations:^{
                    
                    linkContainer.component.uicomponent.transform = CGAffineTransformScale(linkContainer.component.uicomponent.transform, 1/(1+scale), 1/(1+scale));
                }];
                
            }
            [linkContainer runLinkageContainerWidth:(wchange * rate) Height:(hchange * rate)];
        }
    }
}

//Added by Adward 13-10-25 联动图片手势缩放
-(void)runLinkageContainerScale:(float)scale rate:(float)lastRate//12.25 modified
{
    if(self.entity.beLinkageArray.count !=0)
    {
        for (int i =0; i<self.entity.beLinkageArray.count; i++)
        {
            HLLinkageEntity *linkEntity = [self.entity.beLinkageArray objectAtIndex:i];
            NSString * linkID = linkEntity.linkID;
            float rate = linkEntity.rate;
            rate = rate * lastRate;
            lastRate = rate;
            HLContainer *linkContainer =  [self.pageController getContainerByID:linkID];
//            if (scale > 1.0)
//            {
//                scale *= rate;
//            }
//            else if (scale < 1.0)
//            {
//                scale /= rate;
//            }
            CGAffineTransform currentTransform = linkContainer.component.uicomponent.transform;
            CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
            [linkContainer.component.uicomponent setTransform:newTransform];
            [linkContainer runLinkageContainerScale:scale rate:(lastRate *rate)];//Added by Adward 13-10-25 联动图片缩放
        }
    }
}

//Added by Adward 13-11-21 联动图片内部缩放
-(void)runLinkageContainerScrollView
{
    if (self.entity.beLinkageArray.count !=0)
    {
        for (int i =0; i<self.entity.beLinkageArray.count; i++)
        {
            HLLinkageEntity *linkEntity = [self.entity.beLinkageArray objectAtIndex:i];
            NSString *linkID = linkEntity.linkID;
            float rate = linkEntity.rate;
            HLContainer *linkContainer = [self.pageController getContainerByID:linkID];
            ImageComponent * linkageCom = (ImageComponent *)linkContainer.component;
            ImageComponent * imageComponent = (ImageComponent *)self.component;
            //            NSLog(@"linkRate:%f",rate);
            CGFloat scale = (imageComponent.linkSizeRate - lastImageRate + 1.0) * rate;
            float curScale = [[linkageCom.imv.layer valueForKeyPath: @"transform.scale"] floatValue];
            //            NSLog(@"1curScale = %f",curScale);
            scale = MIN(scale, kMaxScale / curScale);
            scale = MAX(scale, kMinScale / curScale);
            CGAffineTransform currentTransform = linkageCom.imv.transform;
            CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
            [linkageCom.imv setTransform:newTransform];
            lastImageRate = imageComponent.linkSizeRate;
        }
    }
}

- (void)dealloc
{
    [self.component unloadView];
    [self stopView];
    [self.caseIdArray removeAllObjects];        //陈星宇，11.2，内存
//    [self.caseIdArray release];
    [self.inSpotContainers removeAllObjects];   //陈星宇，11.2，内存
    [self.inSpotContainers release];
    
    [self.component release];
    [self.entity release];
    //    [entity release];
    if ([self.entity respondsToSelector:@selector(dealloc)]) {
        //        NSLog(@"entity 进入dealloc");
    }
    [super dealloc];
	
}



@end
