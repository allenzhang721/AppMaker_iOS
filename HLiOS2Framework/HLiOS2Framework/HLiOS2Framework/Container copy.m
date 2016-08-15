//
//  Container.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//


#import "Container.h"
#import "PageController.h"
#import "CaseComponent.h"

@implementation Container


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
@synthesize isGroupPlay;
@synthesize componetRect;
@synthesize isSpotTrigger;

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

-(BOOL) runBehavior:(NSString *) eventName index:(int)index//2013.04.22
{
    if (self.isCleaned == YES)
    {
        return YES;
    }
    BehaviorEntity *behavior = [self.entity.behaviors objectAtIndex:index];
    NSString *functionName = [NSString stringWithString:behavior.functionName];
    
    BOOL value = NO;
    if (([functionName isEqualToString:@"FUNCTION_PAGE_CHANGE"] ||
         [functionName isEqualToString:@"FUNCTION_GOTO_PAGE"] ||
         [functionName isEqualToString:@"FUNCTION_BACK_LASTPAGE"] ||
         [functionName isEqualToString:@"FUNCTION_GOTO_LASETPAGE"]))
    {
        value =  YES;
    }
    
    if ([eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CLICK"] ||
         [eventName isEqualToString:@"BEHAVIOR_ON_COUNTER_NUMBER"] ||
         [eventName isEqualToString:@"BEHAVIOR_ON_ANIMATION_END_AT"])
    {
        [self.behaviorController runBehavior:self.entity.entityid entity:behavior];
    }
    return value;
}

-(Boolean) runBehaviorWithEntity:(BehaviorEntity *)behavior
{
    if (self.isCleaned == YES)
    {
        return YES;
    }
    Boolean value = NO;
    if (([behavior.functionName isEqualToString:@"FUNCTION_PAGE_CHANGE"] ||
         [behavior.functionName isEqualToString:@"FUNCTION_GOTO_PAGE"] ||
         [behavior.functionName isEqualToString:@"FUNCTION_BACK_LASTPAGE"] ||
         [behavior.functionName isEqualToString:@"FUNCTION_GOTO_LASETPAGE"]))
    {
        value = YES;
    }
    [self.behaviorController runBehavior:self.entity.entityid entity:behavior];
    return value;
}

-(BOOL) runBehavior:(NSString *) eventName
{
    if (self.isCleaned == YES)
    {
        return YES;
    }
    Boolean isTrigger = NO;
    Boolean isTriigerOnTap = YES;
    if (self.entity.behaviors.count == 0 && self.componetRect.size.width == 0 && self.componetRect.size.height == 0)
    {//没有设置behavior的情况要赋初值
        self.componetRect = self.component.uicomponent.frame;
    }
    for (int i = 0; i < [self.entity.behaviors count]; i++)
    {
        BehaviorEntity *behavior = [self.entity.behaviors objectAtIndex:i];
        NSString *functionName = [NSString stringWithString:behavior.functionName];
        if ([eventName isEqualToString:@"BEHAVIOR_ON_ENTER_SPOT"])
        {
            if (self.isSpotTrigger == YES)
            {
                [self inSpotCheck];
            }
            else
            {
                self.isSpotTrigger = [self inSpotCheck];
            }
            break;
        }
        else
        {
            if (([eventName isEqualToString:@"BEHAVIOR_ON_OUT_SPOT_CHECK"]))
            {
                self.componetRect = self.component.uicomponent.frame;
                if (self.isSpotTrigger == YES)
                {
                    [self outSpotCheck];
                }
                else
                {
                    self.isSpotTrigger = [self outSpotCheck];
                }
                break;
            }
            else
            {
                if (([eventName isEqualToString:@"BEHAVIOR_ON_OUT_SPOT"]))
                {
                    if (self.isSpotTrigger == YES)
                    {
                         [self onOutSpot];
                    }
                    else
                    {
                        self.isSpotTrigger = [self onOutSpot];
                    }
                    break;
                }
                else
                {
                    if ([behavior.eventName compare:eventName] == NSOrderedSame)
                    {
                        if([eventName isEqualToString:@"BEHAVIOR_ON_MOUSE_UP"])
                        {
                            isTriigerOnTap = NO;
                        }
                        isTrigger = YES;
                        [self.behaviorController runBehavior:self.entity.entityid entity:behavior];
                    }
                }
            }
            if (([functionName isEqualToString:@"FUNCTION_PAGE_CHANGE"] ||
                 [functionName isEqualToString:@"FUNCTION_GOTO_PAGE"] ||
                 [functionName isEqualToString:@"FUNCTION_BACK_LASTPAGE"] ||
                 [functionName isEqualToString:@"FUNCTION_GOTO_LASETPAGE"] || isCleaned))
            {
                if ([UIAccelerometer sharedAccelerometer].delegate)
                    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
                return YES;
            }
        }
    }
    if (([eventName isEqualToString:@"BEHAVIOR_ON_MOUSE_UP"]) && (isTrigger == NO))
    {
        if (isTriigerOnTap == YES)
        {
            [self.pageController onTap];
        }
    }
    return NO;
}

-(Boolean) inSpotCheck
{
    return [self.behaviorController checkInSpot:self.entity.entityid  step:@"BEHAVIOR_ON_ENTER_SPOT"];
}

-(Boolean) outSpotCheck
{
    return [self.behaviorController checkInSpot:self.entity.entityid  step:@"BEHAVIOR_ON_OUT_SPOT_CHECK"];
}

-(Boolean) onOutSpot
{
    return [self.behaviorController checkInSpot:self.entity.entityid  step:@"BEHAVIOR_ON_OUT_SPOT"];
}

-(void) reset
{
    if (self.component != nil) 
    {
        [self setRotation:[self.entity.rotation floatValue]];
        [self resetAnchorPoint:[self.entity.rotation floatValue]];
        [self setX:[self.entity.x floatValue]];
        [self setY:[self.entity.y floatValue]];
        [self setWidth:[self.entity.width floatValue]];
        [self setHeight:[self.entity.height floatValue]];
        self.component.uicomponent.hidden = self.entity.isHideAtBegining;
        self.component.hidden = self.component.uicomponent.hidden;
    }
}

-(void) beginView
{
    allPlayCount = self.entity.repeatCount;
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
        animation.view       = self.component.uicomponent;
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
                Container *container = [self.pageController.objects objectAtIndex:i];
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
//    self.component.uicomponent.hidden = NO;
//    self.component.hidden = NO;
//    [self show];
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

-(void) bounceBack
{
    [UIView beginAnimations:@"MoveBack" context:nil];
    [UIView setAnimationDuration:0.50];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.component.uicomponent.frame = self.componetRect;
    [UIView commitAnimations];
}

-(void) show
{
    component.uicomponent.layer.opacity = 1.0;
    component.uicomponent.hidden = NO;
    component.hidden = NO;
    [component show];
    [self onShow];
}

-(void) hide
{
    component.uicomponent.layer.opacity = 0.0;
    component.uicomponent.hidden = YES;
    component.hidden = YES;
    [component hide];
    [self onHidde];
}

-(void) playAnimation
{
    if ([self.entity.animations count] == 0)
    {
        return;
    }
    Boolean isAnimationLoop = NO;
    Animation *an = [self.entity.animations objectAtIndex:self.animationPlayIndex];
    if (an.isPaused == YES)
    {
         [self playAnimationAtIndex:self.animationPlayIndex];
    }
    else
    {
        self.animationPlayIndex  = 0;
        for (int i = 0 ; i < [self.entity.animations count]; i++)
        {
            Animation *animation = [self.entity.animations objectAtIndex:i];
            if (animation.view != self.component.uicomponent)
            {
                animation.view = self.component.uicomponent;
            }
            animation.container = self;
            [animation stop];
        }
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
            [self playAnimationAtIndex:self.animationPlayIndex];
        }

    }
}

-(void) pauseAnimation
{
    Animation *animation = [self.entity.animations objectAtIndex:self.animationPlayIndex];
    if (animation.view != self.component.uicomponent)
    {
        animation.view = self.component.uicomponent;
    }
    animation.container = self;
    [animation pause];
}

-(void) playAnimationAtIndex:(int)index
{
    if (index < 0 || self.entity.animations.count == 0 || index >= self.entity.animations.count) {
        return;
    }
    self.animationPlayIndex = index;
    Animation *animation = [self.entity.animations objectAtIndex:self.animationPlayIndex];
    if (animation.view != self.component.uicomponent)
    {
        animation.view = self.component.uicomponent;
    }
    animation.container = self;
    if (animation.isPaused == NO)
    {
        [animation.view.layer removeAllAnimations];
    }
//    self.component.uicomponent.hidden = NO;
//    self.component.hidden = NO;
//    [self show];
    [animation play];
    for(int i = 0; i < [self.entity.behaviors count];i++)
    {
        BehaviorEntity *behaviorEntity = [self.entity.behaviors objectAtIndex:i];
        if ([behaviorEntity.behaviorValue intValue] == index)
        {
            [self runBehavior:@"BEHAVIOR_ON_ANIMATION_PLAY_AT"];
        }
    }
}

-(void) stopAnimation
{
    for (int i = 0 ; i < [self.entity.animations count]; i++)
    {
        Animation *animation = [self.entity.animations objectAtIndex:i];
        animation.view       = self.component.uicomponent;
        animation.container  = self;
        [animation stop];
        animation.view       = nil;
        animation.container  = nil;
    }
    [self delAnimationPlayCounter];
    [self reset];
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
    [self runBehavior:@"BEHAVIOR_ON_ANIMATION_PLAY"];
}

- (void)checkAnimationRepeat
{
    if (self.pageController.currentPageEntity.isGroupPlay) {
        return;
    }
    isPlayingAnimationCount++;
    if (isPlayingAnimationCount >= self.entity.animations.count)
    {
        if (allPlayCount == 0)
        {
            isPlayingAnimationCount = 0;
            [self playAnimation];
        }
        else
        {
            if (allPlayCount > 1)
            {
                allPlayCount--;
                isPlayingAnimationCount = 0;
                [self playAnimation];
            }
        }
    }
}

-(void) onAnimationEnd
{
    if ((self.animationPlayIndex + 1) == [self.entity.animations count])
    {
        [self delAnimationPlayCounter];
    }
    if (!self.isSinglePlay && (self.pageController.currentPageEntity.isGroupPlay || self.isPlayAnimationAtBegining == YES))
    {
        
        self.isSinglePlay = NO;
        int index = self.animationPlayIndex;
        for(int i = 0; i < [self.entity.behaviors count];i++)
        {
            BehaviorEntity *behaviorEntity = [self.entity.behaviors objectAtIndex:i];
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
        else
        {
            self.animationPlayIndex++;
            [self playAnimationAtIndex:self.animationPlayIndex];
        }
    }
    else
    {
        int index = self.animationPlayIndex;
        for(int i = 0; i < [self.entity.behaviors count];i++)
        {
            BehaviorEntity *behaviorEntity = [self.entity.behaviors objectAtIndex:i];
            if ([behaviorEntity.behaviorValue intValue] == index && [behaviorEntity.eventName isEqualToString:@"BEHAVIOR_ON_ANIMATION_END_AT"])
            {
                if ([self runBehavior:@"BEHAVIOR_ON_ANIMATION_END_AT" index:i])
                {
                    return;
                }
            }
        }
        if ([self runBehavior:@"BEHAVIOR_ON_ANIMATION_END"])
        {
            return;
        }
    }
    [self checkAnimationRepeat];
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

- (void)dealloc 
{
   // NSLog(@"Container Dealloc");
   
    [self stopView];
//    if ([self.component retainCount] > 1)
//    {
//        NSLog(@"%d",[self.entity retainCount]);
//    }
    [self.caseIdArray release];
    [self.inSpotContainers release];
    [self.component release];
    [self.entity release];
    [super dealloc];
	
}



@end
