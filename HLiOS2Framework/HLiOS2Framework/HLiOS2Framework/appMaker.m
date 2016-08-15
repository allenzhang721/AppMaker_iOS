//
//  appBook.m
//  MoueeIOS2Core
//
//  Created by Allen on 12-11-29.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "appMaker.h"
#import "HLBookController.h"

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface appMaker ()
{
    UIImageView *defaultImgView;
    UIInterfaceOrientation statusBarOrientation;
}

@end

@implementation appMaker

@synthesize rootViewController;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareToWeibo:) name:@"ShareToWeibo" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageIsCollected:) name:@"PageIsCollected" object:nil];
    }
    
    return self;
}

-(void) setup
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];      //陈星宇，11.22，statusbar日文版会出现
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [self.bookController setup:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];        //陈星宇，11.13，适配
    [self.rootViewController presentModalViewController:self.bookController.bookviewcontroller animated:NO];//书架点击的书需要在此弹出
}

//-(NSString *) getBookType
//{
//    if (self.bookController.entity != nil)
//    {
//        return self.bookController.entity.bookType;
//    }
//    else
//    {
//        return nil;
//    }
//}

-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [self.bookController checkOrientation:interfaceOrientation];
}

-(Boolean) loadBookEntity:(NSString *) root
{
    //ios6
    Boolean loadSuccess = YES;
    statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    self.bookController = [[[HLBookController alloc] init] autorelease];
    self.bookController.apBook = self;
    loadSuccess = [self.bookController loadBookEntity:root];
    
    //防止发布端 启动时有空白页闪动
    [self showDefaultImgView];
    
    return loadSuccess;
}

- (void)showDefaultImgView
{
    if (!defaultImgView)
    {
        defaultImgView = [[[UIImageView alloc] init] autorelease];
        [self.rootViewController.view addSubview:defaultImgView];
    }
    UIImage *defaultImg = nil;
    //ios5
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    if (self.bookController.entity.isVerHorMode == YES)
    {
        if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
        {
            if (UIDeviceOrientationIsPortrait(deviceOrientation))
            {
                defaultImg = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
                if (UIDeviceOrientationPortraitUpsideDown == deviceOrientation)
                {
                    defaultImgView.transform = CGAffineTransformMakeRotation(M_PI);
                }
            }
            else
            {
                defaultImg = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
                if (UIDeviceOrientationLandscapeRight == deviceOrientation)
                {
                    defaultImgView.transform = CGAffineTransformMakeRotation(M_PI);
                }
            }
        }
        else
        {
            if (UIDeviceOrientationIsPortrait(statusBarOrientation))
            {
                defaultImg = [UIImage imageNamed:@"Default-Landscape~ipad.png"];
                if (UIDeviceOrientationPortraitUpsideDown == statusBarOrientation)
                {
                    defaultImgView.transform = CGAffineTransformMakeRotation(M_PI);
                }
            }
            else
            {
                defaultImg = [UIImage imageNamed:@"Default-Landscape~ipad.png"];
            }
        }
    }
    else
    {
        if (self.bookController.entity.isVerticalMode == YES)
        {
            defaultImg = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
            if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
            {
                if (UIDeviceOrientationLandscapeRight == deviceOrientation)
                {
                    defaultImgView.transform = CGAffineTransformMakeRotation(M_PI);
                }
            }
            else
            {
                if (UIDeviceOrientationLandscapeRight == statusBarOrientation)
                {
                    defaultImgView.transform = CGAffineTransformMakeRotation(M_PI);
                }
            }
        }
        else
        {
            defaultImg = [UIImage imageNamed:@"Default-Landscape~ipad.png"];
            if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
            {
                if (UIDeviceOrientationPortrait == deviceOrientation)
                {
                    defaultImgView.transform = CGAffineTransformMakeRotation(M_PI);
                }
            }
            else
            {
                if (UIDeviceOrientationPortrait == statusBarOrientation)
                {
                    defaultImgView.transform = CGAffineTransformMakeRotation(M_PI);
                }
            }
        }
    }
    
    defaultImgView.image = defaultImg;
    defaultImgView.frame = CGRectMake(0, 0, defaultImg.size.width, defaultImg.size.height);
}

-(void) openBook
{
    [self.bookController openBook];
}

-(Boolean) isFree
{
    return self.bookController.entity.isFree;
}

-(void) displayWatermark:(Boolean) value
{
    self.bookController.entity.isFree = value;
}

-(void) closeBook
{
    if ([self.delegate respondsToSelector:@selector(onCloseingBook)])
    {
        [self.delegate onCloseingBook];
    }
    
    [self.bookController.bookviewcontroller dismissModalViewControllerAnimated:NO];
    self.bookController = nil;
    if ([self.delegate respondsToSelector:@selector(onCloseBook)])
    {
        [self.delegate onCloseBook];
    }
    
}

-(void) startView
{
    if (defaultImgView)
    {
        [defaultImgView removeFromSuperview];
        defaultImgView = nil;
    }
    [self.bookController strartView];
}

-(void) hideBackButton
{
    self.bookController.isHideBackBtn = YES;
}

- (void)hideWeiboButton
{
    self.bookController.isHideWeiboBtn = YES;
}

-(UIView *) getBookContentView
{
    return self.bookController.bookviewcontroller.view;
}

-(NSString *) getBookCurPageIndex
{
    return [self.bookController getCurPageIndex];
}

-(BookType) getBookType
{
    return [self.bookController getBookType];
}

-(void)setJapaneseLanguage
{
    
}

- (void)shareToWeibo:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(shareToWeibo:image:type:)])
    {
        [self.delegate shareToWeibo:[(NSDictionary *)notification.object objectForKey:@"content"]
                              image:[(NSDictionary *)notification.object objectForKey:@"path"]
                               type:[[(NSDictionary *)notification.object objectForKey:@"type"] intValue]];
    }
}

- (void)pageIsCollected:(NSNotification *)notification
{
    BOOL isCollected = [notification.object boolValue];
    if ([self.delegate respondsToSelector:@selector(bookPageIsCollected:)])
    {
        [self.delegate bookPageIsCollected:isCollected];
    }
}

- (BOOL) openBookWithRootViewController:(UIViewController *)root bookDirectoryPath:(NSString *)bookPath theDelegate:(id<appMakerDelegate>)theDelegate hiddenBackIcon:(BOOL)hideBack hiddenShareIcon:(BOOL)hideShare {
    
    if ((self.rootViewController == nil && root == nil) || bookPath == nil || [bookPath isEqualToString:@""] ) {
        
        if (root == nil || bookPath == nil || [bookPath isEqualToString:@""]) {
            
            return NO;
        }
    }
    
    if (root) {
        
        self.rootViewController = root;
    }
    
    self.delegate = theDelegate;

    if (![self loadBookEntity:bookPath]) {
        
        return NO;
    }
    
    if (hideBack) {
        
        [self hideBackButton];
    }
    
    if (hideShare) {
        
        [self hideWeiboButton];
    }
    
    [self setup];
    [self openBook];
    [self startView];
    
    return YES;
}

+ (BOOL) openBookWithRootViewController:(UIViewController *)root bookDirectoryPath:(NSString *)bookPath theDelegate:(id<appMakerDelegate>)theDelegate hiddenBackIcon:(BOOL)hideBack hiddenShareIcon:(BOOL)hideShare {
    
    appMaker *maker = [[[appMaker alloc] init] autorelease];
    
    return [maker openBookWithRootViewController:root bookDirectoryPath:bookPath theDelegate:theDelegate hiddenBackIcon:hideBack hiddenShareIcon:hideShare];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShareToWeibo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PageIsCollected" object:nil];
    [super dealloc];
}

@end













