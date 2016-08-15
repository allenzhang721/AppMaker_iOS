//
//  AutoScrollableComponent.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-9-10.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "AutoScrollableComponent.h"
#import "HLBehaviorEntity.h"
#import "HLContainer.h"
#define kRate 768/1024.0
#define kMinSpeed 0.5
@implementation AutoScrollableComponent

- (id)initWithEntity:(HLContainerEntity *)entity
{
    self = [super init];
    if (self != nil)
    {
        self.entity = (AutoScrollableEntity *)entity;
        
        curScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake([entity.x floatValue], [entity.y floatValue], [entity.width floatValue], [entity.height floatValue])] autorelease];
        curScrollView.scrollEnabled = NO;
        curScrollView.showsHorizontalScrollIndicator = NO;
        curScrollView.showsVerticalScrollIndicator = NO;
        UISwipeGestureRecognizer *swipelLeft = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeLeft:)] autorelease];
        UISwipeGestureRecognizer *swipeRight = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeRight:)] autorelease];
        if (self.entity.isVertical)
        {
            swipelLeft.direction = UISwipeGestureRecognizerDirectionUp;
            swipeRight.direction = UISwipeGestureRecognizerDirectionDown;
        }
        else
        {
            swipelLeft.direction = UISwipeGestureRecognizerDirectionLeft;
            swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        }
        
        [curScrollView addGestureRecognizer:swipelLeft];
        [curScrollView addGestureRecognizer:swipeRight];
        
        self.uicomponent = curScrollView;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
        speed = 0;
        [self performSelector:@selector(loadImg) withObject:self afterDelay:0];
        timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)loadImg
{
    float top = 0;
    for (int i = 0; i < self.entity.images.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *imagePath = [self.entity.images objectAtIndex:i];
        imagePath = [[self.entity.rootPath stringByAppendingPathComponent:self.entity.dataid] stringByAppendingPathComponent:imagePath];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        if (self.entity.isVertical)
        {
            button.frame = CGRectMake(0, top, [self.entity.width floatValue], image.size.height / image.size.width * [self.entity.width floatValue]);
            top += button.frame.size.height;
        }
        else
        {
            button.frame = CGRectMake(top, 0, image.size.width / image.size.height * [self.entity.height floatValue], [self.entity.height floatValue]);
            top += button.frame.size.width;
        }
        button.contentMode = UIViewContentModeScaleToFill;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;
        button.tag = i;
        [button addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [curScrollView addSubview:button];
        
    }
    if (self.entity.isVertical)
    {
        curScrollView.contentSize = CGSizeMake(curScrollView.frame.size.width, top);
    }
    else
    {
        curScrollView.contentSize = CGSizeMake(top, curScrollView.frame.size.height);
    }
    speed = 15.0 / self.entity.timerDelay;
    if (speed < kMinSpeed)
    {
        speed = kMinSpeed;
    }
    NSLog(@"speed:%f",speed);
}

- (void)itemClicked:(UIButton *)sender
{
    for (int i = 0; i < [self.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.entity.behaviors objectAtIndex:i];
        if (sender.tag == [behavior.behaviorValue integerValue] && [behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CLICK"])
        {
            if ([self.container runBehaviorWithEntity:behavior])
            {
                return;
            }
        }
    }
}

-(void) onSwipeLeft:(UIGestureRecognizer*)gestureRecognizer
{
    if (speed < 0)
    {
        speed = -speed;
    }
}

-(void) onSwipeRight:(UIGestureRecognizer*)gestureRecognizer
{
    if (speed > 0)
    {
        speed = -speed;
    }
}

- (void)timerUpdate
{
    if (self.entity.isVertical)
    {
        if (curScrollView.contentOffset.y < 0 || curScrollView.contentOffset.y > curScrollView.contentSize.height - curScrollView.frame.size.height)
        {
            speed = -speed;
        }
        curScrollView.contentOffset = CGPointMake(0, curScrollView.contentOffset.y + speed * kRate);//将speed转化为高度，不断调整contentOffset
    }
    else
    {
        if (curScrollView.contentOffset.x < 0 || curScrollView.contentOffset.x > curScrollView.contentSize.width - curScrollView.frame.size.width)
        {
            speed = -speed;
        }
        curScrollView.contentOffset = CGPointMake(curScrollView.contentOffset.x + speed, 0);
    }
}

- (void)stop
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)dealloc
{
    [self.entity release];
    [self.uicomponent removeFromSuperview]; //陈星宇，11.4
    [self.uicomponent release];
    
    [super dealloc];
}

@end
