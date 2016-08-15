//
//  MovementAnimation.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MovementAnimation.h"
#import "AnimationDecoder.h"

@implementation MovementAnimation

@synthesize points;
@synthesize aspect;
- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        points = [[NSMutableArray alloc] initWithCapacity:1];
		aspect = NO;
    }
    
    return self;
}

-(void) playHandler
{
    [super playHandler];
    if (self.isPaused == YES)
    {
        return;
    }
    if (self.view != nil)
	{
        
        self.containerRect = self.view.frame;//added by Adward 13-11-14 解决按轨迹移动第二次播放图片消失
		CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        CGFloat totalDist = 0.0;
        CGFloat timeTotalDist = 0.0;
        for (int i = 0; i < [self.points count];i++)
        {
            CGPoint p1;
            NSValue *v1 = [self.points objectAtIndex:i];
            [v1 getValue:&p1];
            if ((i+1) >= [self.points count]) 
            {
                break;
            }
            else
            {
                CGPoint p2;
                NSValue *v2 = [self.points objectAtIndex:i+1];
                [v2 getValue:&p2];
                CGFloat xDist = (p1.x - p2.x);
                CGFloat yDist = (p1.y - p2.y);
                CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
                totalDist += distance;
            }
        }
        NSMutableArray *kta = [[NSMutableArray alloc] initWithCapacity:10];
        [kta addObject:[NSNumber numberWithFloat:0.0]];
        for (int i = 0; i < [self.points count];i++)
        {
            CGPoint p1;
            NSValue *v1 = [self.points objectAtIndex:i];
            [v1 getValue:&p1];
            if ((i+1) >= [self.points count]) 
            {
                break;
            }
            else
            {
                CGPoint p2;
                NSValue *v2 = [self.points objectAtIndex:i+1];
                [v2 getValue:&p2];
                CGFloat xDist = (p1.x - p2.x);
                CGFloat yDist = (p1.y - p2.y);
                CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
                timeTotalDist  += distance / totalDist;
                NSNumber *time = [NSNumber numberWithFloat:timeTotalDist];
                [kta addObject:time];
            }
        }
        animation.keyTimes = kta;
        [kta release];
		if (self.aspect)
		{
			CGMutablePathRef path = CGPathCreateMutable();
			for (int i = 0; i < [self.points count];)
			{
				CGPoint point;
				NSValue *value = [self.points objectAtIndex:i];
				[value getValue:&point];
				CGPathMoveToPoint(path, NULL,point.x ,point.y);
				if ((i+1) >= [self.points count]) 
				{
					break;
				}
				else
				{
					CGPoint point2;
					NSValue *value2 = [self.points objectAtIndex:i+1];
					[value2 getValue:&point2];
					if ((i+2) < [self.points count])
					{
						CGPoint point3;
						NSValue *value3 = [self.points objectAtIndex:(i+2)];
						[value3 getValue:&point3];
						CGPathAddCurveToPoint(path, NULL, point.x, point.y, point2.x, point2.y, point3.x, point3.y);
						i = i+2;
					}
					else
					{
						CGPathAddCurveToPoint(path, NULL, point.x, point.y, point2.x, point2.y, point2.x, point2.y);
						break;
					}
				}				
			}
			[animation setPath:path];
			[animation setDuration:self.duration]; 
			animation.rotationMode = kCAAnimationRotateAuto;
			animation.fillMode = kCAFillModeForwards;
			[animation setRemovedOnCompletion:NO];
			if (self.times > 0 )
			{
				animation.repeatCount = self.times;
			}
			if (self.isLoop == YES) 
			{
				animation.repeatCount = HUGE_VALF;
			}
            [animation setFillMode:kCAFillModeForwards];
            animation.removedOnCompletion =NO;
            [animation setDelegate:self];
            [animation setBeginTime:CACurrentMediaTime()];
          //  self.view.layer.opacity = 1.0;
		//	[self.view.layer addAnimation:animation forKey:@"movementAnimation"];
            
            ////
            
            
            CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fadeIn.fromValue = [NSNumber numberWithFloat:[self.container.entity.alpha floatValue]];
            fadeIn.toValue   = [NSNumber numberWithFloat:[self.container.entity.alpha floatValue]]; 
            fadeIn.duration  = self.duration;
            [fadeIn setFillMode:kCAFillModeForwards];
            fadeIn.removedOnCompletion =NO;
            
            CAAnimationGroup *group = [CAAnimationGroup animation]; 
            [group setFillMode:kCAFillModeForwards];
            group.removedOnCompletion =NO;
            group.delegate = self;
            [group setDuration:self.duration]; 
            [group setAnimations: [NSArray arrayWithObjects:animation,fadeIn, nil]];
            if (self.times > 0 )
            {
                group.repeatCount = self.times;
            }
            if (self.isLoop == YES) 
            {
                group.repeatCount = HUGE_VALF;
            }
            [group setBeginTime:CACurrentMediaTime()];
            [self.view.layer addAnimation:group forKey:@"scaleAnimation"];
            
		}
		else 
		{
			
			[animation setValues:self.points];
			[animation setDuration:self.duration];
            [animation setFillMode:kCAFillModeForwards];
            animation.removedOnCompletion =NO;
			animation.calculationMode = kCAAnimationCubic;
            [animation setDelegate:self];
			if (self.times > 0 )
			{
				animation.repeatCount = self.times;
			}
			if (self.isLoop == YES) 
			{
				animation.repeatCount = HUGE_VALF;
			}
            [animation setBeginTime:CACurrentMediaTime()];
           // self.view.layer.opacity = 1.0;
			[self.view.layer addAnimation:animation forKey:@"movementAnimation"];
            
            //
            
            CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fadeIn.fromValue = [NSNumber numberWithFloat:[self.container.entity.alpha floatValue]]; 
            fadeIn.toValue   = [NSNumber numberWithFloat:[self.container.entity.alpha floatValue]]; 
            fadeIn.duration  = self.duration;
            [fadeIn setFillMode:kCAFillModeForwards];
            fadeIn.removedOnCompletion =NO;
            
            CAAnimationGroup *group = [CAAnimationGroup animation]; 
            [group setFillMode:kCAFillModeForwards];
            group.removedOnCompletion =NO;
            group.delegate = self;
            [group setDuration:self.duration]; 
            [group setAnimations: [NSArray arrayWithObjects:animation,fadeIn, nil]];
            if (self.times > 0 )
            {
                group.repeatCount = self.times;
            }
            if (self.isLoop == YES) 
            {
                group.repeatCount = HUGE_VALF;
            }
            [group setBeginTime:CACurrentMediaTime()];
            [self.view.layer addAnimation:group forKey:@"scaleAnimation"];
			
		}
        
	}
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag//???
{
    [super animationDidStop:theAnimation finished:flag];
//    self.view.frame = ((CALayer*)(self.view.layer.presentationLayer)).frame;
    NSInteger count = [self.points count];
    if (flag &&      [theAnimation isKindOfClass:[CAKeyframeAnimation class]]
 && count > 0) 
    {
        NSValue *value0 =[self.points objectAtIndex:count-1];
        CGPoint point;
        [value0 getValue:&point];
        self.view.center = point;
        if (self.aspect) 
        {
            [self.view.layer removeAnimationForKey:@"scaleAnimation"];
        }
        else 
        {
            [self.view.layer removeAnimationForKey:@"scaleAnimation"];
            [self.view.layer removeAnimationForKey:@"movementAnimation"];
        }
    }
//    self.view.bounds = ((CALayer*)(self.view.layer.presentationLayer)).bounds;
}

-(void) decode:(TBXMLElement *) data
{
    [super decode:data];
    float sx = [AnimationDecoder getSX];
    float sy = [AnimationDecoder getSY];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXMLElement* timeElement =  [EMTBXML childElementNamed:@"PlayTimes" parentElement:data];
    if (timeElement != nil)
    {
        if ([EMTBXML childElementNamed:@"Aspect" parentElement:data])
        {
            NSString *aspectStr    = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Aspect" parentElement:data]];
            self.aspect = [aspectStr boolValue];
        }
        
        NSString *timesstr  = [EMTBXML textForElement:[EMTBXML childElementNamed:@"PlayTimes" parentElement:data]];
        self.times  = [timesstr floatValue] + 1;
        
        if (self.times < 0.1 && self.times > -0.1)
        {
            self.isLoop = YES;
        }
        TBXMLElement *pointst = [EMTBXML childElementNamed:@"Points"  parentElement:data];
        if (pointst)
        {
            TBXMLElement *point   = [EMTBXML childElementNamed:@"Point"  parentElement:pointst];
            while (point != nil)
            {
                NSString *x = [EMTBXML textForElement:[EMTBXML childElementNamed:@"X" parentElement:point]];
                NSString *y = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Y" parentElement:point]];
                CGPoint  p  = CGPointMake([x floatValue]*sx, [y floatValue]*sy);
                [self.points addObject:[NSValue valueWithBytes:&p objCType:@encode(CGPoint)]];
                point = [EMTBXML nextSiblingNamed:@"Point" searchFromElement:point];
            }
        }        
    }
    else
    {
        self.times  = 1;
    }
    [pool release];
}

-(void)reset//modified by Adward 13-12-27
{
    [self.view.layer setValue:[NSNumber numberWithFloat:0]forKeyPath:@"transform.rotation"];
    self.view.frame = self.containerRect;
    [self.view.layer setValue:[NSNumber numberWithFloat:self.containerRotation] forKeyPath:@"transform.rotation"];
    [self.view.layer removeAllAnimations];
    self.view.layer.opacity = [self.container.entity.alpha floatValue];
    self.view.layer.speed      = 1.0;
    self.view.layer.timeOffset = 0.0;
    self.view.layer.beginTime  = 0.0;
    self.isPaused = NO;
    self.isPlaying = NO;
}

- (void)dealloc
{
    //NSLog(@"Animation dealloc");
	[self.points removeAllObjects];
    [self.points release];
    [super dealloc];
}


@end
