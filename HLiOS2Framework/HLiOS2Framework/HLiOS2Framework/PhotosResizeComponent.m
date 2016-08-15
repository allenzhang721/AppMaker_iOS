//
//  PhotosResizeComponent.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-30.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "PhotosResizeComponent.h"
#import "HLContainer.h"
#import "HLPageController.h"
#import "appMaker.h"


#define KNOTIFICATION_PAGEDRAGGING      @"PageBeginDragging"

@implementation PhotosResizeComponent

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        self.entity = (PhotosResizeEntity *)entity;
        
        imgArray = [[NSMutableArray alloc] init];
        imgBgArray = [[NSMutableArray alloc] init];
        curIndex = 0;
        isLoad = NO;
        progress = 0;
        count = self.entity.imageSourceArray.count;
        
        showImgRectArr = [[NSArray alloc] initWithArray:self.entity.showImgRectArr];
        imgOriSizeArr = [[NSArray alloc] initWithArray:self.entity.imgOriSizeArr];
        imgSourceArray = [[NSArray alloc] initWithArray:self.entity.imageSourceArray];
        
        BOOL showPageControl = self.entity.isShowControllerPoint;
        if (showPageControl)
        {
            originalRect = CGRectMake([self.entity.x intValue], [self.entity.y intValue], [self.entity.width intValue], [self.entity.height intValue] - 30);
        }
        else
        {
            originalRect = CGRectMake([self.entity.x intValue], [self.entity.y intValue], [self.entity.width intValue], [self.entity.height intValue]);
        }
        
        componentView = [[[UIView alloc] initWithFrame:CGRectMake([self.entity.x intValue], [self.entity.y intValue], [self.entity.width intValue], [self.entity.height intValue])] autorelease];
        [componentView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)] autorelease]];
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer)];
        if (count > 1)
        {
            [componentView addGestureRecognizer:panGesture];
        }
        
        curPageControl = [[[HLPageControl alloc] initWithFrame:CGRectMake(0, [self.entity.height intValue] - 30, [self.entity.width intValue], 24) pageCount:count isHorizon:YES] autorelease];
        [componentView addSubview:curPageControl];
        curPageControl.deleage = self;
        [curPageControl setCurIndex:0];
        curPageControl.userInteractionEnabled = NO;
        if (count <= 1)
        {
            curPageControl.hidden = YES;
        }
        if (!showPageControl)
        {
            curPageControl.hidden = YES;
        }
        
        pressView = [[[HLPushPopPressView alloc] initWithFrame:CGRectMake(0, 0, originalRect.size.width, originalRect.size.height)] autorelease];
        pressView.hidden = YES;
        [pressView setBackgroundColor:[UIColor clearColor]];
        pressView.pushPopPressViewDelegate = self;
        [componentView addSubview:pressView];
        
        self.uicomponent = componentView;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
    }
    return self;
}

- (void)beginView
{
    [self setImage];
}

- (void)setContainer:(HLContainer *)curContainer
{
    container = curContainer;
    if (curContainer && !isLoad)
    {
        isLoad = YES;
        scrWidth = (float)self.container.pageController.pageViewController.view.frame.size.width;
        scrHeight = (float)self.container.pageController.pageViewController.view.frame.size.height;
        [self setViewContent];
        [super beginView];
    }
}

- (HLContainer *)container
{
    return container;
}

- (void)setViewContent
{
    pressView.rootViewController = self.container.pageController.pageViewController;
    
    curScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, originalRect.size.width, originalRect.size.height)] autorelease];
    curScrollView.showsHorizontalScrollIndicator = NO;
    curScrollView.showsVerticalScrollIndicator = NO;
    curScrollView.delegate = self;
    curScrollView.pagingEnabled = YES;
    curScrollView.backgroundColor = [UIColor whiteColor];
//    curScrollView.bounces = NO;
    curScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    NSString *path = [self.entity.rootPath stringByAppendingPathComponent:self.entity.dataid];
    
    for (int i = 0; i < count; i++)
    {
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(originalRect.size.width * i, 0, originalRect.size.width, originalRect.size.height)] autorelease];
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        view.clipsToBounds = YES;
        
        CGRect rect = CGRectFromString([showImgRectArr objectAtIndex:i]);
        CGSize size = CGSizeFromString([imgOriSizeArr objectAtIndex:i]);
        float scale = originalRect.size.width / rect.size.width;
        UIImageView *img = [[[UIImageView alloc] initWithFrame:CGRectMake(-rect.origin.x * scale, -rect.origin.y * scale, size.width * scale, size.height * scale)] autorelease];
        img.contentMode = UIViewContentModeScaleToFill;
        if (i == 0)
        {
            NSString *imgPath = [path stringByAppendingPathComponent:[imgSourceArray objectAtIndex:i]];
            [img setImage:[UIImage imageWithContentsOfFile:imgPath]];
        }
        
        [view addSubview:img];
        [curScrollView addSubview:view];
        [imgArray addObject:img];
        [imgBgArray addObject:view];
    }
    curScrollView.contentSize = CGSizeMake(originalRect.size.width * count, originalRect.size.height);
    [curScrollView bringSubviewToFront:[imgBgArray objectAtIndex:curIndex]];
    [pressView addSubview:curScrollView];
    
    blackBgView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, scrWidth, scrHeight)] autorelease];
    blackBgView.backgroundColor = [UIColor blackColor];
    blackBgView.hidden = YES;
    [pressView.rootViewController.view  addSubview:blackBgView];
    
    //topBar
    topBarView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, scrWidth, 44)] autorelease];
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)] autorelease];
    tapGesture.delegate = self;
    [topBarView addGestureRecognizer:tapGesture];
    [pressView.rootViewController.view addSubview:topBarView];
    topBarView.backgroundColor = [UIColor blackColor];
    topBarView.hidden = YES;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(topBarView.frame.size.width - 55, 6, 32, 32);
    [closeBtn setImage:[UIImage imageNamed:@"ResizePhotosCloseUp.png"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"ResizePhotosCloseDown.png"] forState:UIControlStateSelected];
    [closeBtn setImage:[UIImage imageNamed:@"ResizePhotosCloseDown.png"] forState:UIControlStateHighlighted];
    [closeBtn setImage:[UIImage imageNamed:@"ResizePhotosCloseDown.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [topBarView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(closeBtn.frame.origin.x - 45, 4, 36, 36);
    [shareBtn setImage:[UIImage imageNamed:@"ResizePhotosShareUp.png"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"ResizePhotosShareDown.png"] forState:UIControlStateSelected];
    [shareBtn setImage:[UIImage imageNamed:@"ResizePhotosShareDown.png"] forState:UIControlStateHighlighted];
    [shareBtn setImage:[UIImage imageNamed:@"ResizePhotosShareDown.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [topBarView addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    titleLab = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrWidth, 44)] autorelease];
    [topBarView addSubview:titleLab];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = [self.entity.titleArr objectAtIndex:curIndex];;
    titleLab.textColor = [UIColor whiteColor];
    
    //bottomBar
    decLab = [[[UILabel alloc] initWithFrame:CGRectMake(0,scrHeight - 44, scrWidth, 44)] autorelease];
    [pressView.rootViewController.view addSubview:decLab];
    decLab.backgroundColor = [UIColor blackColor];
    decLab.font = [UIFont systemFontOfSize:14];
    decLab.textAlignment = NSTextAlignmentCenter;
    decLab.text = [self.entity.decArr objectAtIndex:curIndex];;
    decLab.textColor = [UIColor whiteColor];
    decLab.hidden = YES;
    
    audioImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ResizePhotosAudioUp.png"]];
    [componentView addSubview:audioImg];
    audioImg.frame = CGRectMake(0, 0, 60, 60);
    audioImg.hidden = YES;
        
    [self checkShowAudio];
    
    pressView.hidden = NO;
}

//解决ios5按钮和手势冲突问题 2013.04.22
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    
    return YES;
}

- (void)myProgressTask
{
    progress += 0.01;
    HUD.progress = progress / duration;
    if (progress >= duration) {
        [timer invalidate];
        timer = nil;
        [HUD hide:YES];
        progress = 0;
    }
}

- (void)setImage
{
    for (int i = 0; i < count; i++)
    {
        UIImageView *image = [imgArray objectAtIndex:i];
//        if (i < curIndex - 1 || i > curIndex + 1)
//        {
//            [image setImage:nil];
//        }
//        else
//        {
            NSString *path = [self.entity.rootPath stringByAppendingPathComponent:self.entity.dataid];
            NSString *imgPath = [path stringByAppendingPathComponent:[imgSourceArray objectAtIndex:i]];
            [image setImage:[UIImage imageWithContentsOfFile:imgPath]];
//        }
    }
}

- (void)closeBtnClicked
{
    [pressView moveToOriginalFrameAnimated:YES];
}

- (void)shareBtnClicked
{
    NSString *imgPath = [self.entity.rootPath stringByAppendingPathComponent:self.entity.dataid];
    NSString *path = [imgPath stringByAppendingPathComponent:[imgSourceArray objectAtIndex:curIndex]];
    NSString *content = @"应用分享";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareToWeibo" object:[NSDictionary dictionaryWithObjectsAndKeys: path, @"path", content, @"content", [NSNumber numberWithInt:WeiboTypeDefault], @"type", nil]];
}

- (void)checkShowAudio
{
    if (![[self.entity.audioSourceArr objectAtIndex:curIndex] isEqualToString:@""])
    {
        if (pressView.isFullscreen)
        {
            [audioImg removeFromSuperview];
            [pressView.rootViewController.view addSubview:audioImg];
            audioImg.frame = CGRectMake(60, 655, audioImg.frame.size.width, audioImg.frame.size.height);
            [self stopAudio];
            
            NSString *path = [self.entity.rootPath stringByAppendingPathComponent:self.entity.dataid];
            NSString *audiopath = [path stringByAppendingPathComponent:[self.entity.audioSourceArr objectAtIndex:curIndex]];
            NSURL *url = [NSURL fileURLWithPath:audiopath];
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
            [audioPlayer play];
            duration = audioPlayer.duration;
            
            HUD = [[HLMBProgressHUD alloc] initWithView:audioImg];
            [audioImg addSubview:HUD];
            HUD.mode = HLMBProgressHUDModeDeterminate;
            [HUD show:YES];
            timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(myProgressTask) userInfo:nil repeats:YES];
        }
        else
        {
            [audioImg removeFromSuperview];
            [componentView addSubview:audioImg];
            audioImg.frame = CGRectMake(20, originalRect.size.height - 20 - audioImg.frame.size.height, audioImg.frame.size.width, audioImg.frame.size.height);
        }
        audioImg.hidden = NO;
    }
}

- (void)hideAudio
{
    [self stopAudio];
    audioImg.hidden = YES;
}

- (void)stopAudio
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
        progress = 0;
    }
    if (audioPlayer)
    {
        [audioPlayer stop];
        [audioPlayer release];
        audioPlayer = nil;
    }
    if (HUD)
    {
        [HUD removeFromSuperview];
        [HUD hide:NO];
        [HUD release];
        HUD = nil;
    }
    
}

- (void)zoomCurImg:(BOOL)showBar
{
    pressView.userInteractionEnabled = NO;
    topBarView.userInteractionEnabled = NO;
    UIImageView *img = [imgArray objectAtIndex:curIndex];
    CGRect oriRect = img.frame;
    [UIView animateWithDuration:2.5 delay:0 options:UIViewAnimationCurveEaseOut animations:^{//此类中的动画不能用UIViewAnimationOptionsCurveEaseOut 这两种动画的加速是不一样的。
        img.frame = CGRectMake(oriRect.origin.x - oriRect.size.width / 2, oriRect.origin.y - oriRect.size.height / 2, oriRect.size.width * 2, oriRect.size.height * 2);
    } completion:^(BOOL finished) {
        pressView.userInteractionEnabled = YES;
        topBarView.userInteractionEnabled = YES;  
        if (showBar)
        {
            [self showBgView];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_PAGEDRAGGING object:nil];
    }];
}

- (void)viewChangeToFullscreen
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_PAGEDRAGGING object:nil];
    curScrollView.contentSize = CGSizeMake(scrWidth * count, curScrollView.frame.size.height);
   
    [UIView animateWithDuration:.75 delay:0 options:UIViewAnimationCurveEaseIn animations:^{//此类中的动画不能用UIViewAnimationOptionsCurveEaseIn 这两种动画的加速是不一样的。
        curScrollView.contentOffset = CGPointMake(scrWidth * curIndex, 0);
    } completion:^(BOOL finished) {
        curScrollView.frame = CGRectMake(curScrollView.frame.origin.x, curScrollView.frame.origin.y, scrWidth, scrHeight);
    }];
    
    [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
        for (int i = 0; i < count; i++)
        {
            [self setFullscreenImgRect:i];
        }
    } completion:^(BOOL finished) {
    }];
}

- (void)viewChangeToOriginal
{
    [self beginPinch];
    curScrollView.contentSize = CGSizeMake(originalRect.size.width * count, originalRect.size.height);
    
    [UIView animateWithDuration:.75 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
        curScrollView.contentOffset = CGPointMake(originalRect.size.width * curIndex, 0);
    } completion:^(BOOL finished) {
        curScrollView.frame = CGRectMake(curScrollView.frame.origin.x, curScrollView.frame.origin.y, originalRect.size.width, originalRect.size.height);
    }];
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
        for (int i = 0; i < count; i++)
        {
            [self setOriginalImgRect:i];
        }
    } completion:^(BOOL finished) {
    }];
}

- (void)setFullscreenImgRect:(int)index
{
    UIView *curBgView = [imgBgArray objectAtIndex:index];
    curBgView.frame = CGRectMake(scrWidth * index, curBgView.frame.origin.y, curBgView.frame.size.width, curBgView.frame.size.height);
//
    UIImageView *img = [imgArray objectAtIndex:index];
    CGSize size = CGSizeFromString([imgOriSizeArr objectAtIndex:index]);
    float width = size.width;
    float height = size.height;
    float x = 0;
    float y = 0;
    if (scrWidth / scrHeight > width / height)
    {
        if (height > scrHeight)
        {
            width = width / height * scrHeight;
            height = scrHeight;
            x = (scrWidth - width) / 2;
        }
        else
        {
            x = (scrWidth - width) / 2;
            y = (scrHeight - height) / 2;
        }
    }
    else
    {
        if (width > scrWidth)
        {
            height = height / width * scrWidth;
            width = scrWidth;
            y = (scrHeight - height) / 2;
        }
        else
        {
            x = (scrWidth - width) / 2;
            y = (scrHeight - height) / 2;
        }
    }
    img.frame = CGRectMake(x, y, width, height);
}

- (void) setOriginalImgRect:(int)index
{
    UIView *curBgView = [imgBgArray objectAtIndex:index];
    curBgView.frame = CGRectMake(originalRect.size.width * index, curBgView.frame.origin.y, curBgView.frame.size.width, curBgView.frame.size.height);
    
    UIImageView *img = [imgArray objectAtIndex:index];
    CGRect rect = CGRectFromString([showImgRectArr objectAtIndex:index]);
    CGSize size = CGSizeFromString([imgOriSizeArr objectAtIndex:index]);
    float scale = originalRect.size.width / rect.size.width;
    img.frame = CGRectMake(-rect.origin.x * scale, -rect.origin.y * scale, size.width * scale, size.height * scale);
}

- (void)pushPopPressViewWillAnimateToFullscreenWindowFrame:(HLPushPopPressView *)pushPopPressView duration:(NSTimeInterval)duration
{
    pushPopPressView.userInteractionEnabled = NO;
    curScrollView.backgroundColor = [UIColor clearColor];
    [self viewChangeToFullscreen];
    if (count <= 1)
    {
        [curScrollView addGestureRecognizer:panGesture];
    }
}

- (void)pushPopPressViewWillAnimateToOriginalFrame:(HLPushPopPressView *)pushPopPressView duration: (NSTimeInterval)duration
{
    pushPopPressView.userInteractionEnabled = NO;
    [self viewChangeToOriginal];
    if (count <= 1)
    {
        [curScrollView removeGestureRecognizer:panGesture];
    }
}

- (void)pushPopPressViewDidAnimateToFullscreenWindowFrame:(HLPushPopPressView *)pushPopPressView
{
    [self checkShowAudio];
    [pressView.rootViewController.view bringSubviewToFront:topBarView];
    [pressView.rootViewController.view bringSubviewToFront:decLab];
        
    if ([[self.entity.zoomArr objectAtIndex:curIndex] boolValue])
    {
        [self zoomCurImg:YES];
    }
    else
    {
        pushPopPressView.userInteractionEnabled = YES;
        [self showBgView];
    }
}

- (void)pushPopPressViewDidAnimateToOriginalFrame:(HLPushPopPressView *)pushPopPressView
{
    [self checkShowAudio];
    curScrollView.backgroundColor = [UIColor whiteColor];
    pushPopPressView.userInteractionEnabled = YES;
}

- (void)pushPopPressViewDidReceiveTap:(HLPushPopPressView *)pushPopPressView
{
    if (pressView.isFullscreen)
    {
        if (topBarView.hidden)
        {
            [self showBarView];
        }
        else
        {
            [self hideBarView];
        }
    }
}

- (void)beginPinch
{
    [self hideBarAndBgView];
    [self hideAudio];
}

- (void)endPinch
{
    
}

- (void)showBarView
{
    topBarView.hidden = NO;
    decLab.hidden = NO;
    topBarView.alpha = 0;
    decLab.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        topBarView.alpha = 1;
        decLab.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideBarView
{
    [UIView animateWithDuration:.3 animations:^{
        topBarView.alpha = 0;
        decLab.alpha = 0;
    } completion:^(BOOL finished) {
        topBarView.hidden = YES;
        decLab.hidden = YES;
    }];
}

- (void)showBgView
{
    blackBgView.alpha = 0;
    blackBgView.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        blackBgView.alpha = 1;
    } completion:^(BOOL finished) {
        [self showBarView];
    }];
}

- (void)hideBarAndBgView
{
    if (blackBgView.hidden == NO) {
        [UIView animateWithDuration:.3 animations:^{
            topBarView.alpha = 0;
            decLab.alpha = 0;
            blackBgView.alpha = 0;
        } completion:^(BOOL finished) {
            blackBgView.hidden = YES;
            topBarView.hidden = YES;
            decLab.hidden = YES;
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int offset = scrollView.contentOffset.x;
    int index = offset / scrollView.frame.size.width;
    if (index == curIndex)
    {
        return;
    }
    if (pressView.isFullscreen && [[self.entity.zoomArr objectAtIndex:curIndex] boolValue])
    {
        [self setFullscreenImgRect:curIndex];
    }
    
    curIndex = index;
    
    if (pressView.isFullscreen && [[self.entity.zoomArr objectAtIndex:curIndex] boolValue])
    {
        [self zoomCurImg:NO];
    }
    
    UIView *curBgView = [imgBgArray objectAtIndex:curIndex];
    if (curBgView)
    {
        [scrollView bringSubviewToFront:curBgView];
    }
    [curPageControl setCurIndex:curIndex];
    titleLab.text = [self.entity.titleArr objectAtIndex:curIndex];
    decLab.text = [self.entity.decArr objectAtIndex:curIndex];
//    [self setImage];
    [self hideAudio];
    [self checkShowAudio];
}

- (void)pageControlValueChange:(int)index
{
    
}

- (void)tap
{
    
}

- (void)panGestureRecognizer
{
    
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
    [self stopAudio];
    [audioImg release];
    [panGesture release];
    [blackBgView removeFromSuperview];
    blackBgView = nil;
    [topBarView removeFromSuperview];
    topBarView = nil;
    [decLab removeFromSuperview];
    decLab = nil;
    [curScrollView removeFromSuperview];
    curScrollView = nil;
    [pressView removeFromSuperview];
    pressView = nil;
    
    [imgSourceArray release];
    [self.entity release];
    [self.uicomponent release];
    [showImgRectArr release];
    [imgBgArray release];
    [imgArray release];
    [imgOriSizeArr release];
    
    [super dealloc];
}

@end
