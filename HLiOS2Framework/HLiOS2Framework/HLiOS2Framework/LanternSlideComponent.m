//
//  LanternSlideComponent.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-9-12.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "LanternSlideComponent.h"
#import <QuartzCore/QuartzCore.h>
#import "HLContainer.h"

@interface LanternSlideComponent () {
    
   NSInteger changeCompeleteAdd;//Mr.chen, 04.18.2014, 幻灯片动画结束时，添加changeCompleteAdd记录翻页方向
}

@end

@implementation LanternSlideComponent

- (NSString *)getImagePath:(int)index
{
    if (index <0 || isnan(index))//adward 1.21 change时有－1，避免崩溃
    {
        return nil;
    }
    NSString *path = [self.entity.rootPath stringByAppendingPathComponent:self.entity.dataid];
    NSString *curImgPath = [path stringByAppendingPathComponent:[self.entity.showImgArr objectAtIndex:index]];
    return curImgPath;
}

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        isPlaying = NO;
        
        self.entity = (LanternSlideEntity *)entity;
        
        // 这个不是放这里的_(:з」∠)_，因为 componentView 还没初始化，给他添手势等于没有, Mr.chen, 14.3.16
//        if (!entity.isPlayAudioOrVideoAtBegining)//浏览开始时自动播放不添加手势事件adward 1.22
//        {
//            if (self.entity.isClickSwitch)
//            {
//                [componentView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)] autorelease]];
//            }
//            if (self.entity.isSlideSwitch)
//            {
//                [self addGesture];
//            } 
//        }
        
        UIView *bgView = [[[UIView alloc] initWithFrame:CGRectMake([self.entity.x floatValue], [self.entity.y floatValue], [self.entity.width floatValue], [self.entity.height floatValue])] autorelease];
        bgView.clipsToBounds = YES;
        
        componentView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, [self.entity.width floatValue], [self.entity.height floatValue])] autorelease];
        
        componentView.clipsToBounds = YES;
        [bgView addSubview:componentView];
        
        if (!entity.isPlayAudioOrVideoAtBegining)//浏览开始时自动播放不添加手势事件adward 1.22
        {
            if (self.entity.isClickSwitch)
            {
                [componentView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)] autorelease]];
            }
            if (self.entity.isSlideSwitch)
            {
                [self addGesture];
            }
            
        }
        
        self.curShowImg = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.entity.width floatValue], [self.entity.height floatValue])] autorelease];
        [componentView addSubview:self.curShowImg];
        
        self.nextShowImg = [[[UIImageView alloc] initWithFrame:self.curShowImg.frame] autorelease];
        [componentView addSubview:self.nextShowImg];
        self.nextShowImg.hidden = YES;
        
        self.uicomponent = bgView;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
        [self initState:0];
    }
    return self;
}

- (void)initState:(int)startIndex
{
    curIndex = startIndex;
    //    loopCount = 0;
    curAdd = 1;
    if (self.entity.showImgArr.count >= 2)
    {
        self.curShowImg.image = [UIImage imageWithContentsOfFile:[self getImagePath:curIndex]];
        self.nextShowImg.image = [UIImage imageWithContentsOfFile:[self getImagePath:curIndex + 1]];
    }
    else if(self.entity.showImgArr.count == 1)
    {
        self.curShowImg.image = [UIImage imageWithContentsOfFile:[self getImagePath:0]];
    }
    self.curShowImg.hidden = NO;
    self.nextShowImg.hidden = YES;
}

- (void)beginView
{
    [super beginView];
    if (self.entity.showImgArr.count < 2)
    {
        return;
    }
    if (self.entity.isAutoPlay)
    {
        [self play];
    }
}

- (void)play
{
    if (isPlaying)
    {
        return;//adward 2.20 播放过程中点击play，继续播放
    }
    [self playHandler];
    
}

//自动播放控制
-(void)playHandler
{
    //    if (!isContinue)            //hehehehehehe
    //    {
    //        [self stop]; adward 1.22
    [self.container onPlay];
    //    }
    
    self.entity.isAutoPlay = YES;
    isStopAutoPlay = NO;
    curIndex = [self getEnableIndex:curIndex];
    [super play];
    [self stopTimer];
    timer =[NSTimer scheduledTimerWithTimeInterval:[[self.entity.animationDelayArr objectAtIndex:curIndex] floatValue] / 1000.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    isPlaying = YES;
}



#pragma mark Core Animation

- (void)playAnimation
{
//    NSLog(@"playAnimation");
    int add = 0;
    int recentIndex = curIndex + add;
    if (curAdd == -1)//如果是翻到上一页 则读取上一页的动画信息
    {
        //        NSLog(@"curAdd == -1");
        add = -1;
        recentIndex = [self getEnableIndex:recentIndex];
        NSLog(@"recentIndex:%d",recentIndex);
    }
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = [[self.entity.animationDurationArr objectAtIndex:recentIndex] floatValue] / 1000.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    switch ([[self.entity.animationTypeArr objectAtIndex:recentIndex] intValue])
    {
        case AnimationTypeFade:
            animation.type = kCATransitionFade;
            break;
        case AnimationTypePush:
            animation.type = kCATransitionPush;
            break;
        case AnimationTypeReveal:
            animation.type = kCATransitionReveal;
            break;
        case AnimationTypeMoveIn://覆盖
            animation.type = kCATransitionMoveIn;
            break;
        case AnimationTypeCubeEffect://立方体
            animation.type = @"cube";
            break;
        case AnimationTypeSuckEffect:
            animation.type = @"suckEffect";//吸收
            break;
        case AnimationTypeFlipEffect:
            animation.type = @"oglFlip";//翻转
            break;
        case AnimationTypeRippleEffect:
            animation.type = @"rippleEffect";
            break;
        case AnimationTypePageCurl:
            animation.type = @"pageCurl";
            break;
        case AnimationTypePageUnCul:
            animation.type = @"pageUnCurl";
            break;
        default:
            break;
    }
    //        NSLog(@"type:%@",animation.type);
    if (self.entity.isSwipe == NO)//自动播放 Adward 13-11-22
    {
        if (curAdd == -1)
        {
            switch ([[self.entity.animationDirArr objectAtIndex:recentIndex] intValue])
            {
                case HLAnimationDirLeft:
                    animation.subtype = kCATransitionFromRight;
                    break;
                case HLAnimationDirDown:
                    animation.subtype = kCATransitionFromTop;
                    break;
                case HLAnimationDirRight:
                    animation.subtype = kCATransitionFromLeft;
                    break;
                case HLAnimationDirUp:
                    animation.subtype = kCATransitionFromBottom;
                    break;
                default:
                    break;
            }
        }
        else
        {
            switch ([[self.entity.animationDirArr objectAtIndex:recentIndex] intValue])
            {
                    
                case HLAnimationDirLeft:
                    animation.subtype = kCATransitionFromLeft;
                    break;
                case HLAnimationDirDown:
                    animation.subtype = kCATransitionFromBottom;
                    break;
                case HLAnimationDirRight:
                    animation.subtype = kCATransitionFromRight;
                    break;
                case HLAnimationDirUp:
                    animation.subtype = kCATransitionFromTop;
                    break;
                default:
                    break;
            }
        }
    }
    else//单独的手势 翻转的手势与实际情况相反 Adward 13-11-22
    {
        if ([animation.type isEqualToString:@"pageUnCurl"])
        {
            switch (self.entity.swipeDir)
            {
                case HLAnimatinoSwipeGestureDirLeft:
                    animation.subtype = kCATransitionFromLeft;
                    break;
                case HLAnimatinoSwipeGestureDirDown:
                    animation.subtype = kCATransitionFromBottom;
                    break;
                case HLAnimatinoSwipeGestureDirRight:
                    animation.subtype = kCATransitionFromRight;
                    break;
                case HLAnimatinoSwipeGestureDirUp:
                    animation.subtype = kCATransitionFromTop;
                    break;
                default:
                    break;
            }
        }
        else
        {
            switch (self.entity.swipeDir)
            {
                case HLAnimatinoSwipeGestureDirLeft:
                    animation.subtype = kCATransitionFromRight;
                    break;
                case HLAnimatinoSwipeGestureDirDown:
                    animation.subtype = kCATransitionFromBottom;
                    break;
                case HLAnimatinoSwipeGestureDirRight:
                    animation.subtype = kCATransitionFromLeft;
                    break;
                case HLAnimatinoSwipeGestureDirUp:
                    animation.subtype = kCATransitionFromTop;
                    break;
                default:
                    break;
            }
        }
        self.entity.isSwipe = NO;//modified by Adward 13-12-18 点击和滑动时，点击的方向与上次滑动方向相同了
    }
    
    NSUInteger cur = [[componentView subviews] indexOfObject:self.curShowImg];
    NSUInteger next = [[componentView subviews] indexOfObject:self.nextShowImg];
    [componentView exchangeSubviewAtIndex:cur withSubviewAtIndex:next];
    [[componentView layer] addAnimation:animation forKey:@"animation"];
}

-(void)animationDidStart:(CAAnimation *)anim
{
    [self beginChangeTo:[self getEnableIndex:curIndex + curAdd]];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    curIndex += curAdd;
    if ((curIndex == self.entity.showImgArr.count -2)&& self.entity.isPlayAtBegining && !self.entity.isLoop)//浏览开始时自动播放结束后添加手势事件adward 1.22
    {
        if (self.entity.isClickSwitch)
        {
            [componentView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)] autorelease]];
        }
        if (self.entity.isSlideSwitch)
        {
            [self addGesture];
        }
        
    }

    [self stopTimer];
    
    if (flag) {     // 一定要加这个保护，Mr.chen, 14.3.16
        self.curShowImg.image = nil;
        self.curShowImg.hidden = NO;
        isPlayAnimation = NO;
        if (self.entity.isAutoPlay)
        {
            if (curIndex + 1 == self.entity.showImgArr.count)//最后一张图片
            {
                if (!self.entity.isLoop)
                {
                    [self.container onPlayEnd];
                    [self stopAutoPlay];
                    return;//如果不循环 则停止
                }
                
                //            else
                //            {
                //                loopCount ++;
                //                if (loopCount != 0 && loopCount >= self.entity.loopCount)
                //                {
                //                    [self stopAutoPlay];
                //                    return;//如果循环次数结束 则停止
                //                }
                //            }
            }
            
            if (!isStopAutoPlay && self.entity.isAutoPlay)
            {
                curAdd = 1;
                isContinue = YES;
                [self playHandler];
            }
        }
        curIndex = [self getEnableIndex:curIndex];
        [self changeCompelete:[self getEnableIndex:curIndex + curAdd]];
    }
    
    isPlaying = NO;//adward 2.20 播放过程中点击play，继续播放
}

-(void)addGesture
{
    if (self.entity.isClickSwitch)
    {
        [componentView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)] autorelease]];
    }
    if (self.entity.isSlideSwitch)
    {
        UISwipeGestureRecognizer *downGesture = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)] autorelease];
        downGesture.direction = UISwipeGestureRecognizerDirectionDown;
        UISwipeGestureRecognizer *upGesture = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)] autorelease];
        upGesture.direction = UISwipeGestureRecognizerDirectionUp;
        UISwipeGestureRecognizer *leftGesture = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)] autorelease];
        leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        UISwipeGestureRecognizer *rightGesture = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)] autorelease];
        rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
        downGesture.delegate = self;
        upGesture.delegate = self;
        leftGesture.delegate = self;
        rightGesture.delegate = self;
        [componentView addGestureRecognizer:downGesture];
        [componentView addGestureRecognizer:upGesture];
        [componentView addGestureRecognizer:leftGesture];
        [componentView addGestureRecognizer:rightGesture];
    }
}

- (void)stopAutoPlay
{
    isStopAutoPlay = YES;
    self.entity.isAutoPlay = NO;
    isContinue = NO;
}

- (void)change:(int)index
{
    [self initState:(index - 1)];
    [self timerUpdate];//adward 1.21 change时应该有动画效果
}

- (void)beginChangeTo:(int)index {
    int cIndex = [self getEnableIndex:index];
    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CHANGE_BEGIN"] == YES)
        {
            if (cIndex == [behavior.behaviorValue intValue])
            {
                if ([self.container runBehaviorWithEntity:behavior])
                {
                    return;
                }
            }
        }
    }
}

- (void)changeCompelete:(int)index {
    int cIndex = ([self getEnableIndex:index - changeCompeleteAdd]);     //Mr.chen, 04.18.2014, 幻灯片动画结束时，添加changeCompleteAdd记录翻页方向
    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CHANGE_COMPLETE"] == YES)
        {
            if (cIndex == [behavior.behaviorValue intValue])
            {
                if ([self.container runBehaviorWithEntity:behavior])
                {
                    return;
                }
            }
        }
    }
}

#pragma mark -
#pragma mark - timer Method

- (void)timerUpdate
{
    if (isPlayAnimation)
    {
        return;
    }
    isPlayAnimation = YES;
    curIndex = [self getEnableIndex:curIndex];
    int nextIndex = curIndex + curAdd;
    nextIndex = [self getEnableIndex:nextIndex];
    if (!self.tmpShowImg)
    {
        self.tmpShowImg = self.curShowImg;
        if (curAdd == -1)
        {
            self.nextShowImg.image = [UIImage imageWithContentsOfFile:[self getImagePath:nextIndex]];
        }
    }
    else
    {
        self.tmpShowImg = self.nextShowImg;
        self.nextShowImg = self.curShowImg;
        self.curShowImg = self.tmpShowImg;
        self.nextShowImg.image = [UIImage imageWithContentsOfFile:[self getImagePath:nextIndex]];
    }
    self.curShowImg.hidden = YES;
    self.nextShowImg.hidden = NO;
    [self playAnimation];
    
}



#pragma mark -
#pragma mark - Gesture

- (void)tapGesture
{
    BOOL isGoPage = [self onTapGesture];
    if(!isGoPage){
        if (curIndex >= [self.entity.showImgArr count])//change时点击第一张无反应 1.23 adward
        {
            curIndex = 0;
        }
        curAdd = 1;
        if (self.entity.isEndToStart)
        {
            [self stopTimer];
            [self timerUpdate];
        }
        else
        {
            if (curIndex < self.entity.showImgArr.count - 1)
            {
                [self stopTimer];
                [self timerUpdate];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationScrollEnabled" object:[NSNumber numberWithBool:YES]];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationScrollEnabled" object:[NSNumber numberWithBool:NO]];//防止滑动翻页的时候导致翻页
    return YES;
}

- (void)onSwipeGesture:(UISwipeGestureRecognizer *)gesture
{
    self.entity.isSwipe = YES;
    if (isPlayAnimation)
    {
        return;
    }
    //    NSLog(@"direction:%d",gesture.direction);
    switch (gesture.direction)
    {
        case UISwipeGestureRecognizerDirectionDown:
            curAdd = -1;
            changeCompeleteAdd = -1;
            self.entity.swipeDir = HLAnimatinoSwipeGestureDirDown;//added by Adward 13-11-26
            break;
        case UISwipeGestureRecognizerDirectionUp:
            curAdd = 1;
            changeCompeleteAdd = 1;
            self.entity.swipeDir = HLAnimatinoSwipeGestureDirUp;
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            curAdd = 1;
            changeCompeleteAdd = 1;
            self.entity.swipeDir = HLAnimatinoSwipeGestureDirLeft;
            break;
        case UISwipeGestureRecognizerDirectionRight:
            curAdd = -1;
            changeCompeleteAdd = -1;
            self.entity.swipeDir = HLAnimatinoSwipeGestureDirRight;
            break;
        default:
            break;
    }
    if (self.entity.isEndToStart)
    {
        [self stopTimer];
        [self timerUpdate];
    }
    else
    {
        if ((curIndex > 0 && curIndex < self.entity.showImgArr.count - 1)||
            (curIndex <= 0 && curAdd == 1) || (curIndex >= self.entity.showImgArr.count - 1 && curAdd == -1))
        {
            [self stopTimer];
            [self timerUpdate];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationScrollEnabled" object:[NSNumber numberWithBool:YES]];
}

- (int)getEnableIndex:(int)index
{
    int cIndex = index;
    int count = self.entity.showImgArr.count;
    if (cIndex > count - 1)
    {
        cIndex = 0;
    }
    if (cIndex < 0)
    {
        cIndex = count - 1;
    }
    return cIndex;
}

- (void)stopTimer
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)pause
{
    isPause = YES;
    [self stopAutoPlay];
    [self stopTimer];
}

- (void)stop
{
    [self stopAutoPlay];
    [self stopTimer];
    [self initState:0];
    self.nextShowImg.image = [UIImage imageWithContentsOfFile:[self getImagePath:0]];//adward 1.22
    self.nextShowImg.hidden = NO;
}

-(void) show
{
    if (self.uicomponent.hidden == YES)
    {
        self.uicomponent.hidden = NO;
    }
}

-(void) hide
{
    if (self.uicomponent.hidden == NO)
    {
        self.uicomponent.hidden = YES;
    }
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];//adward 3.6
    [[componentView layer] removeAllAnimations];
//    [self.tmpShowImg release];
    [self.nextShowImg release];
    [self.curShowImg release];
    [self.uicomponent removeFromSuperview];            //陈星宇，11.4
    [self.uicomponent release];
    [super dealloc];
}

@end
