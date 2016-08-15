    //
//  PageController.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-12.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLPageController.h"
#import "HLContainerDecoder.h"
#import "ImageEntity.h"
#import "ImageComponent.h"
#import "VideoComponent.h"
#import "HLContainerEntity.h"
#import "GifComponent.h"
#import "SWFPlayerComponent.h"
#import "Component.h"
#import "PDFEntity.h"
//#import "iAdComponent.h"
#import "CaseComponent.h"

#import "HLAudioComponent.h"
#import "Animation.h"
#import "TimerComponent.h"

#import "HLSliderFlipController.h"

@interface HLPageController () {
    
    UIImageView *_publicCoverBackground;
    BOOL isRegister;
}

@end

static NSString* const changePublicCoverBackgoundNotification = @"changePublicCoverBackgoundNotification";
static NSString* const changePublicCoverBackgoundResourcePathKey = @"changePublicCoverBackgoundRootPathKey";

static NSString* const changeSingleCoverBackgroundNotification = @"changeSingleCoverBackgroundNotification";
static NSString* const fullCoverBackgroundSourceKey = @"fullCoverBackgroundSourceKey";

@implementation HLPageController
@synthesize bookEntity;
@synthesize pageViewController;
@synthesize rootPath;
@synthesize currentPageEntity;
@synthesize objects;
@synthesize lastPageID;
@synthesize lastPageLinkID;
@synthesize lastPageIsVertical;
@synthesize behaviorController;
@synthesize isAutoPlay;
@synthesize isGroupAutoPlay;
@synthesize groupCounter;
@synthesize isBeginView;
@synthesize cacheImage;

float AUTOPLAY_DELAY = 2.0f;

-(void) setup:(CGRect) rect
{
    if (pageViewController == nil)
    {
        pageViewController = [[HLPageViewController alloc] init];
        pageViewController.view.clipsToBounds = YES;
        pageViewController.view.backgroundColor = [UIColor whiteColor];
            //Mr.chen, 2.25,
        pageViewController.view.frame = rect;
//        pageViewController.view.frame = CGRectMake(0, 44, 320, 480);
        pageViewController.pageController = self;
        self.isBeginView = NO;
        isRegister = NO;
    }
    if (self.cacheImage == nil)
    {
        cacheImage = [[UIImageView alloc] init];
    }
    
    
//    pageViewController.view.backgroundColor = [UIColor clearColor];     //Mr.chen, 2.25,
}

//      >>>>>  1.2 穿透视图
-(void) setup:(CGRect) rect WithClear:(BOOL)clear
{
    if (pageViewController == nil)
    {
        pageViewController = [[HLPageViewController alloc] initWithClear:clear];
        pageViewController.view.clipsToBounds = YES;
        if (clear == YES)
        {
            pageViewController.view.backgroundColor = [UIColor clearColor];
        }
        else
        {
            pageViewController.view.backgroundColor = [UIColor whiteColor];
        }
        
        pageViewController.view.frame = rect;
        pageViewController.pageController = self;
        self.isBeginView = NO;
    }
    if (self.cacheImage == nil)
    {
        cacheImage = [[UIImageView alloc] init];
    }
}
//      <<<<<


-(void) addContainer:(HLContainer *)container
{
//    if (![container.component isKindOfClass:[iAdComponent class]])
//    {
        [self.pageViewController addComponent:container.component];
//    }
    
    container.component.uicomponent.layer.opacity = [container.entity.alpha floatValue];
    if (container.entity.isHideAtBegining == YES)
    {
        container.component.uicomponent.hidden = YES;
    }
    [container setX:[container.entity.x floatValue]];
	[container setY:[container.entity.y floatValue]];
    [container setWidth:[container.entity.width floatValue]];
	[container setHeight:[container.entity.height floatValue]];
	[container setRotation:[container.entity.rotation floatValue]];
    if ([container.entity isKindOfClass:[ImageEntity class]])
    {
        if (((ImageEntity*)container.entity).isZoomByUser == YES)
        {
            [((ImageComponent*)container.component) setImageSize];
        }
       // [self addPushpopView:(UIView*)(container.component.uicomponent)];
    }
    container.component.uicomponent.userInteractionEnabled = YES;
	container.behaviorController = self.behaviorController;
    container.pageController     = self;
	[self resetAnchorPoint:container rotation:[container.entity.rotation floatValue]];
    if (self.objects == nil)
	{
		self.objects = [[NSMutableArray alloc] initWithCapacity:10];
        [self.objects release];
	}
    
	[self.objects addObject:container];
	[container release];
}

- (void)delayRemoveCacheImg
{
    [self.cacheImage removeFromSuperview];
    [self.cacheImage setImage:nil];
}

-(void) beginView
{
    
    NSString *bookID = self.bookEntity.bookid;
    Boolean isNeedPay = [self.pageViewController.pageEntity isNeedPay];
    
    if (isNeedPay) {
        
        Boolean paid = [[NSUserDefaults standardUserDefaults] boolForKey:bookID];
        
        if (paid == NO) {
            
            return ;
        }
        
    }

    [UIAccelerometer sharedAccelerometer].delegate = pageViewController;
    if (self.isBeginView == YES)
    {
        return;
    }
    if (self.bookEntity.isLoadSnap && self.currentPageEntity.isCached == YES)
    {
        [self loadCurrentEntityWithCache];
        if (isPDFCom)
        {
            [self performSelector:@selector(delayRemoveCacheImg) withObject:nil afterDelay:.4];
        }
        else
        {
            [self.cacheImage removeFromSuperview];
            [self.cacheImage setImage:nil];
        }
    }
    self.playCounter     = 0;
    self.groupPlayIndex  = -1;
    self.groupCounter    = 0;
    self.isGroupAutoPlay = self.currentPageEntity.isGroupPlay;
    if (self.isGroupAutoPlay == YES)
    {
        if ([self.currentPageEntity.groups count] > 0)
        {
            NSNumber* delay = [self.currentPageEntity.groupDelay objectAtIndex:0];
            [self performSelector:@selector(playGroup:) withObject:[NSNumber numberWithInt:0] afterDelay:[delay floatValue]/1000];
        }
        else
        {
            self.groupPlayIndex = 0;
        }
    }
    else
    {
        if (self.isAutoPlay == YES)
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(onAutoPlay) withObject:nil afterDelay:AUTOPLAY_DELAY];
        }
        
    }
    
    [self setCaseComponent];
    
    float maxDelayTime = 0;
    float comDelayTime = 0;
    float aniMaxTime = 0;
    
    for (int i = 0 ; i < [self.objects count]; i++)
    {
//        if ([((Container*)[self.objects objectAtIndex:i]).component isKindOfClass:[iAdComponent class]]) //广告需重新加载
//        {
//            [((iAdComponent *)((Container*)[self.objects objectAtIndex:i]).component) reloadiAd];
//            [((Container*)[self.objects objectAtIndex:i]).component.uicomponent removeFromSuperview];
//            [self.pageViewController addComponent:((Container*)[self.objects objectAtIndex:i]).component];
//        }
        //添加启动页容器 adward 13-12-30
        HLPageEntity *startPageEntity = [HLPageDecoder decode:self.bookEntity.launchPage path:self.rootPath];
        if ([self.currentPageEntity.entityid isEqualToString:startPageEntity.entityid])
        {
            HLContainer *container = (HLContainer *)[self.objects objectAtIndex:i];
            comDelayTime = [self startPageTimeWithCom:container.component];
            if (container.entity.animations.count >0)
            {
                aniMaxTime = [self animationTimewithContainer:container];
            }
        }
        maxDelayTime = (maxDelayTime > comDelayTime) ? maxDelayTime : comDelayTime;
        maxDelayTime = (maxDelayTime > aniMaxTime) ? maxDelayTime :aniMaxTime;
        
        if (self.isGroupAutoPlay == YES)
        {
            if([self checkContainerInGroups:((HLContainer*)[self.objects objectAtIndex:i]).entity.entityid] == NO)
            {
                [((HLContainer*)[self.objects objectAtIndex:i]) beginView];
            }
        }
        else
        {
            [((HLContainer*)[self.objects objectAtIndex:i]) beginView];
//            NSLog(@"pageBeginViewe\npageID = %@\npageController = %@\n",self.pageViewController.pageEntity.entityid,self);
        }
    }
    bookEntity.startDelay +=  maxDelayTime;
    
    // >>>>>  Mr.chen, 04.20.2014, add Public Cover background
//    UIImage *PublicBackgroundImage = nil;
//    
//    
//    if (self.currentPageEntity.state == pageEntityStatePublic) {
//        
//        if (self.currentPageEntity.background) {
//            NSString *path = [self.currentPageEntity.background.rootPath stringByAppendingPathComponent:self.currentPageEntity.background.dataid];
//            NSLog(@"PublicBackgroundImagepath =  %@",path);
//            PublicBackgroundImage = [UIImage imageWithContentsOfFile:path];
//        }
//    
//        self.behaviorController.flipController.bookViewController.publicCoverBackGroundImageView.image = PublicBackgroundImage;
//    }
    // <<<<<
    
    self.isBeginView = YES;
    
    if (![self.behaviorController.flipController isKindOfClass:[HLSliderFlipController class]]) {
        
        if ((self.currentPageEntity.state == pageEntityStateNormal) && isRegister == NO) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changepageBackgroundByCover:) name:changeSingleCoverBackgroundNotification object:nil];
            
            isRegister = YES;
        }
    }
}

- (void)changepageBackgroundByCover:(NSNotification *)notification {
    
//    self.pageViewController.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    NSLog(@"adsfasdfsadf;asdfkasfksdfasdkl;fj;asdklj;sadfkjasdfasdkf");
    NSDictionary *dic = notification.userInfo;

    NSString *backgroundresoucePath = dic[fullCoverBackgroundSourceKey];
    UIImage *image = [UIImage imageWithContentsOfFile:backgroundresoucePath];
    
    _publicCoverBackground.image = image;
}

//添加启动页容器 adward 13-12-30
-(float)startPageTimeWithCom:(Component *)com
{
    float musicDuration = 0;
    float videoDuration = 0;
    float gifDuration = 0;
    float timerDuration = 0;
    
    if ([com isKindOfClass:[HLAudioComponent class]])
    {
        HLAudioComponent *audioCom = (HLAudioComponent *)com;
        musicDuration = [audioCom playerDuration];
        musicDuration += audioCom.entity.delayCount;//+delayTime 3.4 adward
        return musicDuration;
    }
    if ([com isKindOfClass:[VideoComponent class]])
    {
        VideoComponent *videoCom = (VideoComponent *)com;
        videoDuration = [videoCom playerDuration];
        videoDuration += videoCom.entity.delayCount;//+delayTime 3.4 adward
        return videoDuration;
    }
    
    if ([com isKindOfClass:[GifComponent class]])
    {
        HLContainerEntity *entity = com.containerEntity;
        gifDuration = ((GifEntity*)entity).duration / 1000;
        return gifDuration;
    }
    if ([com isKindOfClass:[TimerComponent class]])
    {
        timerDuration = ((TimerComponent*)com).maxValue;
        return timerDuration;
    }
    return 0;
}

-(float)animationTimewithContainer:(HLContainer *)con
{
    float aniMaxTime = 0;
    for (int i = 0; i < [con.entity.animations count]; i++)
    {
        Animation *ani = [con.entity.animations objectAtIndex:i];
        aniMaxTime += ani.duration * ani.times;
        aniMaxTime += ani.delay;//+delayTime 3.4 adward
    }
    return aniMaxTime;
}

//添加互斥容器设置
-(void)setCaseComponent
{
    for (int i = 0 ; i < [self.objects count]; i++)
    {
        HLContainer *caseContainer = (HLContainer*)[self.objects objectAtIndex:i];
        if ([caseContainer.component isKindOfClass:[CaseComponent class]])
        {
            NSArray *containerIdArray = ((CaseComponent *)caseContainer.component).caseEntity.containerIdArr;
            for (int j = 0; j < containerIdArray.count; j++)
            {
                for (int c = 0 ; c < [self.objects count]; c++)
                {
                    HLContainer *container = (HLContainer*)[self.objects objectAtIndex:c];
                    if ([container.entity.entityid isEqualToString:[containerIdArray objectAtIndex:j]])
                    {
                        [container.caseIdArray addObject:caseContainer.entity.entityid];
                        break;
                    }
                }
            }
        }
    }
}

-(void) playGroup:(NSNumber *) index
{
    if (self.isBeginView == NO)
    {
        return;
    }
    [self cleanGroupPlay];
    self.groupCounter = 0;
    self.groupPlayIndex = [index intValue];
    if ([index intValue] < [self.currentPageEntity.groups count])
    {
        NSMutableArray *gp = [self.currentPageEntity.groups objectAtIndex:self.groupPlayIndex];
        for (int i = 0 ; i < [gp count] ; i++)
        {
            HLContainer* container  = [self getContainerByID:[gp objectAtIndex:i]];
            container.isGroupPlay = YES;
            [container playAll];
        }
    }
    else
    {
        self.groupPlayIndex = ([self.currentPageEntity.groups count] - 1);
    }
}

-(void) stopGroup:(int) index
{
    NSMutableArray *gp = [self.currentPageEntity.groups objectAtIndex:index];
    for (int i = 0 ; i < [gp count] ; i++)
    {
        HLContainer* container  = [self getContainerByID:[gp objectAtIndex:i]];
        [container stop];
        [container stopAnimation];
        container.isGroupPlay = NO;
    }
    self.groupCounter = 0;
}


-(void) cleanGroupPlay
{
    if (self.groupPlayIndex >= 0)
    {
        NSMutableArray *gp = [self.currentPageEntity.groups objectAtIndex:self.groupPlayIndex];
        for (int i = 0 ; i < [gp count] ; i++)
        {
            HLContainer* container  = [self getContainerByID:[gp objectAtIndex:i]];
            [container stop];
           // [container stopAnimation];
            container.isGroupPlay = NO;
        }
        self.groupCounter = 0;
    }
}

-(Boolean) checkContainerInGroups:(NSString *) containerid
{
    for (int i = 0; i < [self.currentPageEntity.groups count]; i++)
    {
        NSMutableArray *gp = [self.currentPageEntity.groups objectAtIndex:i];
        for (int i = 0 ; i < [gp count] ; i++)
        {
            HLContainer* container  = [self getContainerByID:[gp objectAtIndex:i]];
            if ([container.entity.entityid isEqualToString:containerid])
            {
                return YES;
            }
        }
    }
    return NO;
}

-(Boolean) checkContainerInGroup:(NSString *)containerid
{
    if (self.groupPlayIndex >= 0)
    {
        if ([self.currentPageEntity.groups count] > self.groupPlayIndex)
        {
            NSMutableArray *gp = [self.currentPageEntity.groups objectAtIndex:self.groupPlayIndex];
            for (int i = 0 ; i < [gp count] ; i++)
            {
                HLContainer* container  = [self getContainerByID:[gp objectAtIndex:i]];
                if ([container.entity.entityid isEqualToString:containerid])
                {
                    return YES;
                }
            }
        }
    }
    return NO;
}

-(void) onAutoPlay
{
    if ((self.groupPlayIndex+1) == [self.currentPageEntity.groups count])
    {
        if (self.playCounter <= 0)
        {
            [self.behaviorController nextPage];
        }
    }
    else
    {
        [self playGroup:[NSNumber numberWithInt:++self.groupPlayIndex] ];
    }
  
}

-(void) addCounter:(HLContainer *) container
{
    self.playCounter++;
    if ([self checkContainerInGroup:container.entity.entityid] == YES)
    {
        self.groupCounter++;
    }
}

-(void) delCounter:(HLContainer *) container
{
    self.playCounter--;
    if ([self checkContainerInGroup:container.entity.entityid] == YES)
    {
        self.groupCounter--;
    }
    if (self.isAutoPlay == YES)
    {
        if (self.isGroupAutoPlay == YES)
        {
            if ((self.groupPlayIndex+1) == [self.currentPageEntity.groups count])
            {
                if (self.playCounter <= 0)
                {
                    [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    [self performSelector:@selector(onAutoPlay) withObject:nil afterDelay:AUTOPLAY_DELAY];
                }
            }
            else
            {
                if (self.groupCounter == 0)
                {
                    if ((self.groupPlayIndex+1) < [self.currentPageEntity.groups count])
                    {
                        NSNumber* delay = [self.currentPageEntity.groupDelay objectAtIndex:++self.groupPlayIndex];
                        [self performSelector:@selector(playGroup:) withObject:[NSNumber numberWithInt:self.groupPlayIndex] afterDelay:[delay floatValue]/1000];
                    }
                }
            }
        }
        else
        {
            if (self.playCounter <= 0)
            {
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                [self performSelector:@selector(onAutoPlay) withObject:nil afterDelay:AUTOPLAY_DELAY];
            }
        }
    }
    else
    {
        if (self.isGroupAutoPlay == YES)
        {
            if (self.groupCounter == 0)
            {
                if ((self.groupPlayIndex+1) < [self.currentPageEntity.groups count])
                {
                    NSNumber* delay = [self.currentPageEntity.groupDelay objectAtIndex:++self.groupPlayIndex];
                    [self performSelector:@selector(playGroup:) withObject:[NSNumber numberWithInt:self.groupPlayIndex] afterDelay:[delay floatValue]/1000];
                }
            }
        }
    }
}

-(HLContainer *) getContainerByID:(NSString *) containterid
{
//    NSLog(@"pageID = %@\nCount = %d\npageController = %@",self.pageViewController.pageEntity.entityid,self.objects.count,self);
    for (int i = 0 ; i < [self.objects count] ; i++)
    {
        if([((HLContainer*)[self.objects objectAtIndex:i]).entity.entityid isEqualToString:containterid])
        {
            return [self.objects objectAtIndex:i];
        }
    }
    return nil;
}

-(void) loadCurrentEntityWithCache
{
    if (self.currentPageEntity.isLoaded == NO)
    {
        [HLPageDecoder load:self.currentPageEntity path:self.rootPath];
    }
    if (self.currentPageEntity.background != nil)
    {
        if (self.currentPageEntity.state != pageEntityStatePublic) {
            
            self.currentPageEntity.background.x = 0;
            self.currentPageEntity.background.y = 0;
            self.currentPageEntity.background.width  = self.currentPageEntity.width;
            self.currentPageEntity.background.height = self.currentPageEntity.height;
            self.currentPageEntity.background.rootPath = self.rootPath;
            HLContainer *container = [HLContainerDecoder createContainer:self.currentPageEntity.background pageController:self];
            [self addContainer:container];
        }
        
    }
    BOOL isExistPDF = NO;
    for (int i = 0; i < [self.currentPageEntity.containers count]; i++)
    {
        NSObject *containerentity = [self.currentPageEntity.containers objectAtIndex:i];
        if([containerentity isKindOfClass:[PDFEntity class]])
        {
            isExistPDF = YES;
        }
        if([containerentity isKindOfClass:[HLContainerEntity class]])
        {
            ((HLContainerEntity*)containerentity).rootPath = self.rootPath;
            HLContainer *container = [HLContainerDecoder createContainer:((HLContainerEntity*)containerentity) pageController:self];
            [self addContainer:container];
        }
    }
    if (isExistPDF)
    {
        isPDFCom = YES;
    }
    else
    {
        isPDFCom = NO;
    }
}

-(void) loadEntity:(HLPageEntity *) entity
{
    self.pageViewController.view.frame = CGRectMake(self.pageViewController.view.frame.origin.x, self.pageViewController.view.frame.origin.y, [entity.width floatValue], [entity.height floatValue]);
//    NSLog(@"self.pageViewController.view.frame = asdasdasd%@",NSStringFromCGRect(self.pageViewController.view.frame));
    [self.pageViewController loadPageEntity:entity];
    if (self.currentPageEntity != nil && ![self.currentPageEntity.entityid isEqualToString:entity.linkPageID])//防止屏幕旋转后 返回的页面是本页 2013.04.22
    {
        self.lastPageID     = self.currentPageEntity.entityid;
        self.lastPageLinkID = self.currentPageEntity.linkPageID;
        self.lastPageIsVertical = self.currentPageEntity.isVerticalPageType;
    }
    self.currentPageEntity = entity;
    self.currentPageEntity.isCached = NO;/**********/
    if (self.bookEntity.isLoadSnap && entity.isCached == YES)
    {
//        self.cacheImage.frame = CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue]);
//        [self.cacheImage removeFromSuperview];
//        [self.cacheImage setImage:[UIImage imageWithContentsOfFile:[self.rootPath stringByAppendingPathComponent:entity.cacheImageID]]];
//        [self.pageViewController.view addSubview:self.cacheImage];
        
    }
    else
    {
        if (self.currentPageEntity.isLoaded == NO)
        {
            [HLPageDecoder load:self.currentPageEntity path:self.rootPath];
        }
        
        // >>>>>  Mr.chen, 04.20.2014, Add Public Cover Background
        if (![self.behaviorController.flipController isKindOfClass:[HLSliderFlipController class]]) {
            
            if (entity.state == pageEntityStateNormal) {
                
                if (!_publicCoverBackground) {
                    
                    _publicCoverBackground = [[UIImageView alloc] initWithFrame:self.pageViewController.view.bounds];
                    _publicCoverBackground.backgroundColor = [UIColor whiteColor];
                    [self.pageViewController.view addSubview:_publicCoverBackground];
                    [self.pageViewController.view insertSubview:_publicCoverBackground atIndex:0];
                    
                    [_publicCoverBackground release];
                }
            }
        }
        // <<<<<
        
        if (self.currentPageEntity.background != nil)
        {

            
                self.currentPageEntity.background.x = 0;
                self.currentPageEntity.background.y = 0;
                
                //modified by adward 14-1-2
                HLContainerEntity *background = self.pageViewController.pageEntity.background;
                if (background != nil)
                {
                    self.currentPageEntity.background.width  = self.pageViewController.pageEntity.background.width;
                    self.currentPageEntity.background.height = self.pageViewController.pageEntity.background.height;
                }
                else
                {
                    self.currentPageEntity.background.width  = [NSNumber numberWithFloat:self.pageViewController.view.frame.size.width];
                    self.currentPageEntity.background.height = [NSNumber numberWithFloat:self.pageViewController.view.frame.size.height];
                }
                
                self.currentPageEntity.background.rootPath = self.rootPath;
            
            if (self.currentPageEntity.state != pageEntityStatePublic) {
                
                HLContainer *container = [HLContainerDecoder createContainer:self.currentPageEntity.background pageController:self];
                [self addContainer:container];
                
            } else {
                
                // >>>>>       //Mr.chen, 05.07.2014, fix public cover background
                UIImage *PublicBackgroundImage = nil;
                
                if (entity.state == pageEntityStatePublic) {
                    
                    if (entity.background) {
                        NSString *path = [entity.background.rootPath stringByAppendingPathComponent:entity.background.dataid];
                        NSLog(@"PublicBackgroundImagepath =  %@",path);
                        PublicBackgroundImage = [UIImage imageWithContentsOfFile:path];
                    }
                    self.behaviorController.flipController.bookViewController.publicCoverBackGroundImageView.image = PublicBackgroundImage;
                }
                // <<<<<
            }
        }
        
        // >>>>>  Mr.chen, 04.20.2014, add Public Cover backgorund , if flip the page background color should be white ,otherwase the cache image would be wrong,and slider should be clear to show the backgrond image.
//        if ([self.behaviorController.flipController isKindOfClass:[SliderFlipController class]]) {
        
            pageViewController.view.backgroundColor = [UIColor clearColor];
//        }
        // <<<<<
        
        /* 加载当前页的container */
        for (int i = 0; i < [self.currentPageEntity.containers count]; i++)
        {
            NSObject *containerentity = [self.currentPageEntity.containers objectAtIndex:i];
            if([containerentity isKindOfClass:[HLContainerEntity class]])
            {
                ((HLContainerEntity*)containerentity).rootPath = self.rootPath;
                HLContainer *container = [HLContainerDecoder createContainer:((HLContainerEntity*)containerentity) pageController:self];
                [self addContainer:container];
            }
        }
        
        //      >>>>>  12.27 当前页是否有覆盖页，如果有加载覆盖页
//        if ( [entity.state isEqualToString:@"PAGE_NORMAL_STATE"] && entity.beCoveredPageID != nil && ![@"" isEqualToString:entity.beCoveredPageID])
//        {
//            PageEntity *coverPage = [PageDecoder decode:entity.beCoveredPageID path:bookEntity.rootPath];
//            self.pageViewController.pageEntity = coverPage;
//            [PageDecoder load:coverPage path:bookEntity.rootPath];
//            
//            for (int i = 0 ; i < [coverPage.containers count]; i++)
//            {
//                NSObject *containerentity = [coverPage.containers objectAtIndex:i];
//                if ([containerentity isKindOfClass:[containerentity class]])
//                {
//                    ((ContainerEntity*)containerentity).rootPath = self.rootPath;
//                    Container *container = [ContainerDecoder createContainer:((ContainerEntity*)containerentity) pageController:self];
//                    container.pageController = self;    //指向当前页；
//                    [self addContainer:container];
//                }
//            }
//        }
        //      <<<<<
    }
    



    
    self.pageViewController.rightSwipe.enabled = entity.enableGesture;
    self.pageViewController.leftSwip.enabled   = entity.enableGesture;
    
    if (entity.enbableNavigation == YES)
    {
//        self.pageViewController.rightSwipe.enabled = YES;
//        self.pageViewController.leftSwip.enabled   = YES;
    }
    else
    {
        self.pageViewController.rightSwipe.enabled = NO;
        self.pageViewController.leftSwip.enabled   = NO;
    }
}

-(void) resetAnchorPoint:(HLContainer*)container rotation:(float)rotation
{
	container.component.uicomponent.layer.anchorPoint = CGPointMake(0.5, 0.5);
	float width  = container.component.uicomponent.layer.bounds.size.width/2;
	float height = container.component.uicomponent.layer.bounds.size.height/2;
	float dx = -width *cos(rotation*M_PI / 180.0f) + height*sin(rotation*M_PI / 180.0f);
	float dy = -height*cos(rotation*M_PI / 180.0f) - width *sin(rotation*M_PI / 180.0f);
	container.component.uicomponent.layer.position = CGPointMake(container.component.uicomponent.layer.position.x - dx, container.component.uicomponent.layer.position.y-dy);
}

-(void) clean
{
    [self.pageViewController.curContainerArr removeAllObjects];
    [UIAccelerometer sharedAccelerometer].delegate = nil;
    self.isBeginView = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    for (int m = 0; m < [self.objects count]; m++)
	{
		HLContainer *obj = [self.objects objectAtIndex:m];
		if ([obj isKindOfClass:[HLContainer class]])
		{
            obj.isCleaned = YES;
            [obj.component clean]; 
			[obj.component.uicomponent removeFromSuperview];
		}
	}
    
	[self.objects removeAllObjects];
    
}

-(void) removeVideo
{
    for (int i = 0; i < [self.objects count]; i++)
    {
        HLContainer *obj = [self.objects objectAtIndex:i];
        if ([obj.component isKindOfClass:[VideoComponent class]])
        {
            [obj.component.uicomponent removeFromSuperview];
        }
    }
}

-(void) stopView
{
    for (int i = 0 ; i < [self.objects count]; i++)
	{
		HLContainer *container = [self.objects objectAtIndex:i];
		if ([container isKindOfClass:[HLContainer class]])
		{
			[container stopView];
		}
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.isGroupAutoPlay == YES)
    {
        if ((self.groupPlayIndex+1) < [self.currentPageEntity.groups count])
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self playGroup:[NSNumber numberWithInt:++self.groupPlayIndex]];

        }
        else
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            if ((self.isAutoPlay == YES) && (self.isGroupAutoPlay == YES))
            {
                [self.behaviorController nextPage];
            }
        }
    }
}

-(void) onTap
{
    if((self.isGroupAutoPlay == YES) || ([self.currentPageEntity.groups count] > 0))
    {
        if ((self.groupPlayIndex+1) < [self.currentPageEntity.groups count])
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self playGroup:[NSNumber numberWithInt:++self.groupPlayIndex]];
            
        }
        else
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            if ((self.isAutoPlay == YES))
            {
                [self.behaviorController nextPage];
            }
        }
    }
}

-(void) setupGesture
{
    if (self.pageViewController != nil)
    {
        [self.pageViewController setupGesture];
    }
}

-(void) onSwipRight
{
    
    [self.behaviorController prePage];
}

-(void) onSwipLeft
{
    
    [self.behaviorController nextPage];
}

-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        if(self.currentPageEntity.isVerticalPageType == YES)
        {
            return YES;
        }
    }
    if ([self.currentPageEntity.linkPageID length] > 0 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)dealloc
{
        if (self.currentPageEntity.state == pageEntityStateNormal && isRegister) {
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
    
    if (_publicCoverBackground) {
        
        [_publicCoverBackground removeFromSuperview];
    }
    
    [self.currentPageEntity release];
    [self.objects removeAllObjects];
    [self.objects release];
    [self.lastPageID release];
    [self.lastPageLinkID release];
    [self.cacheImage release];
    [super dealloc];
}

@end
