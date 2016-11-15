//
//  BookController.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-12.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLBookController.h"
#import "HLBookDecoder.h"
#import "HLCoreConfig.h"
#import "ClearView.h"
#import "HLFlipBaseController.h"
#import "HLPageDecoder.h"
#import "TimerComponent.h"
#import "CounterComponent.h"
#import "HLPageDecoder.h"
#import "HLIndesignControlPanelViewController.h"
#import "HLXMLManager.h"
#import "HLDefaultRecord.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define iPhone_book     @"iphone_book"
#define iPhone5_book    @"iphone5_book"
#define iPad_book       @"ipad_book"
//  陈星宇，11.13，适配

@interface HLBookController ()

{
    CGRect frameRect;    //陈星宇，11.13，适配
}

@end

@implementation HLBookController

@synthesize bookmode;
@synthesize bookviewcontroller;
@synthesize rootPath;
@synthesize flipBaseViewController;
@synthesize flipController;
@synthesize controlPanelViewController;
@synthesize apBook;

-(void) setup:(CGRect) rect
{
    if (self.bookviewcontroller == nil)
    {
        self.bookviewcontroller = [[[HLBookViewController alloc] init] autorelease];
        self.bookviewcontroller.view.frame = rect;
        self.bookviewcontroller.view.autoresizesSubviews = NO;
        self.bookviewcontroller.bookController = self;
    }
    else
    {
        self.bookviewcontroller.view.frame = rect;
    }
    
    frameRect = rect;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (iPhone5)
        {
            if ([self.entity.deviceType isEqualToString:iPhone5_book])
            {
               frameRect = CGRectMake(0, 0, 320, 568);
            }
            else  //iphone5打开iphone4的书籍
            {
                if (self.entity.isVerticalMode == YES)
                {
                    frameRect = CGRectMake(0, 44, 320, 480);
                }
                else
                {
                    frameRect = CGRectMake(44, 0, 320, 480);
                }
                
            }
        }
        else
        {
            frameRect = rect;
        }
    }
    else
    {
        frameRect = rect;
    }

    self.bookviewcontroller.view.frame = frameRect;

    if ([self.entity.bookType isEqualToString:@"PDF"] || [self.entity.bookType isEqualToString:@"EPUB"])
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            if (iPhone5)
            {
                self.bookviewcontroller.view.frame = CGRectMake(0, -20, 320, 568);
            }
            else
            {
                self.bookviewcontroller.view.frame = CGRectMake(0, -20, 320, 480);
            }
        }
        else
        {
            self.bookviewcontroller.view.frame = CGRectMake(0, -20, 768, 1024);
        }
        
        
        if (self.controlPanelViewController == nil)
        {
            self.controlPanelViewController = [[[HLBasicControlPanelViewController alloc] init] autorelease];
            if ([self.entity.bookType isEqualToString:@"EPUB"])
            {
                ((HLBasicControlPanelViewController *)self.controlPanelViewController).isHideBackBtn = YES;
                self.ePubViewController.isHideBackBtn = self.isHideBackBtn;
            }
            else
            {
                ((HLBasicControlPanelViewController *)self.controlPanelViewController).isHideBackBtn = self.isHideBackBtn;
            }
            
            ((HLBasicControlPanelViewController *)self.controlPanelViewController).isPDFType = YES;
            ((HLBasicControlPanelViewController *)self.controlPanelViewController).activePushBtn = self.entity.activePush;
        }
        
        self.controlPanelViewController.view.frame = frameRect;
        [self.controlPanelViewController setup:frameRect];
        self.controlPanelViewController.bookController = self;
        if ([self.entity.bookType isEqualToString:@"PDF"])
        {
            [self.bookviewcontroller.view addSubview:self.readerViewController.view];
        }
        else
        {
            [self.bookviewcontroller.view addSubview:self.ePubViewController.view];
        }
        [self.bookviewcontroller.view addSubview:self.controlPanelViewController.view];
        self.bookviewcontroller.view.backgroundColor = [UIColor whiteColor];
        return;
    }
    
    if (!self.bookviewcontroller.publicCoverBackGroundImageView) {
        
        self.bookviewcontroller.publicCoverBackGroundImageView = [[UIImageView alloc] initWithFrame:frameRect];
        self.bookviewcontroller.publicCoverBackGroundImageView.backgroundColor = [UIColor whiteColor];
    }

    
    if(self.flipBaseViewController == nil)
    {
        self.flipBaseViewController = [[[HLFlipBaseViewController alloc] init] autorelease];
        self.flipBaseViewController.view.frame = frameRect;
        self.flipBaseViewController.bookEntity = self.entity;
    }
    else
    {
        self.flipBaseViewController.view.frame = frameRect;
    }
//    self.entity.navType = @"indesign_slider_view";//参数控制
    if (self.controlPanelViewController == nil)
    {
        if ([self.entity.navType isEqualToString:@"threed_navigation_view"])
        {
            self.controlPanelViewController = [[[HLBasicControlPanelViewController alloc] init] autorelease];
            ((HLBasicControlPanelViewController *)self.controlPanelViewController).isHideBackBtn = self.isHideBackBtn;
        }
        else if ([self.entity.navType isEqualToString:@"indesign_slider_view"])
        {
            self.controlPanelViewController = [[[HLIndesignControlPanelViewController alloc] init] autorelease];
            ((HLIndesignControlPanelViewController *)self.controlPanelViewController).isHideBackBtn = self.isHideBackBtn;
            ((HLIndesignControlPanelViewController *)self.controlPanelViewController).isHideWeiboBtn = self.isHideWeiboBtn;
        }
        else
        {
            self.controlPanelViewController = [[[HLMagazineViewController alloc] init] autorelease];
            ((HLMagazineViewController *)self.controlPanelViewController).isHideBackBtn = self.isHideBackBtn;
        }
        self.controlPanelViewController.bookController = self;
    }
    if (self.entity.isVerHorMode == YES)
    {
        [HLPageDecoder setHorVerMode:YES];
    }
    else
    {
        [HLPageDecoder setHorVerMode:NO];
    }
    
//    CGFloat bookViewWidth = CGRectGetWidth(frameRect);
//    CGFloat bookViewHeight = CGRectGetHeight(frameRect);
//    CGFloat entityWidth = self.entity.width;
//    CGFloat entityHeight = self.entity.height;
//    
//    CGFloat bookViewRatio = bookViewWidth / bookViewHeight;
//    CGFloat entityViewRatio = entityWidth / entityHeight;
    
    if (self.entity.isVerticalMode == YES)
        
    {
        float sx =  frameRect.size.width / self.entity.width;
        float sy =  frameRect.size.height / self.entity.height;
        self.controlPanelViewController.sx = sx;
        self.controlPanelViewController.sy = sy;
        [HLPageDecoder setSX:sx];
        [HLPageDecoder setSY:sy];
    }
    else
    {
        float sx =  frameRect.size.height / self.entity.width;
        float sy =  frameRect.size.width / self.entity.height;
        self.controlPanelViewController.sx = sx;
        self.controlPanelViewController.sy = sy;
        [HLPageDecoder setSX:sx];
        [HLPageDecoder setSY:sy];
    }
    if (self.entity.isVerHorMode == YES)
    {
        float sx =  frameRect.size.width / self.entity.height;
        float sy =  frameRect.size.height / self.entity.width;
        self.controlPanelViewController.sx1 = sx;
        self.controlPanelViewController.sy1 = sy;
        [HLPageDecoder setSX1:sx];
        [HLPageDecoder setSY1:sy];
    }

    [self.bookviewcontroller.view addSubview:self.bookviewcontroller.publicCoverBackGroundImageView];
    [self.bookviewcontroller.view addSubview:self.flipBaseViewController.view];
    [self.bookviewcontroller.view addSubview:self.controlPanelViewController.view];
}


-(void) loadPage:(NSString *) pageid
{
    
}

-(Boolean) loadBookEntity:(NSString *) root
{
    self.rootPath = root;
    self.entity   = [HLBookDecoder decode:root];
    
    if (self.entity == nil)
    {
        return NO;
    }
    
    if ([self.entity.bookType isEqualToString:@"PDF"])
    {
        NSString *path = [rootPath stringByAppendingPathComponent:@"book.pdf"];
        NSString *phrase = nil;
        HLReaderDocument *document = [HLReaderDocument withDocumentFilePath:path password:phrase isReload:YES];
        
        CGRect rect;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            if (iPhone5)
            {
                rect = CGRectMake(0, -20, 320, 568);
            }
            else
            {
                rect = CGRectMake(0, -20, 320, 480);
            }
        }
        else
        {
            rect = CGRectMake(0, -20, 768, 1024);
        }
        
        self.readerViewController = [[[HLReaderViewController alloc] initWithReaderDocument:document frame:rect index:1 isPDFBook:YES] autorelease];
        self.readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		self.readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    else if([self.entity.bookType isEqualToString:@"EPUB"])
    {
        NSString *path = [rootPath stringByAppendingPathComponent:@"book.epub"];
        
        NSString *nibName = @"";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            if (iPhone5)
            {
                nibName = @"EPubView_iPhone5";
            }
            else
            {
                nibName = @"EPubView_iPhone4";
            }
        }
        else
        {
            nibName = @"EPubView";
        }
        
        self.ePubViewController = [[[EPubViewController alloc] initWithNibName:nibName bundle:[NSBundle mainBundle]] autorelease];
        [self.ePubViewController loadEpub:[NSURL fileURLWithPath:path]];
        self.ePubViewController.bookController = self;
    }
    
    [self setupOrientation];
    
    return YES;
}

-(void) setupOrientation
{
    if ([self.entity.bookType isEqualToString:@"PDF"] || [self.entity.bookType isEqualToString:@"EPUB"])
    {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        return;
    }
    if (self.entity.isVerHorMode == NO)
    {
        if (self.entity.isVerticalMode == YES)
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        }
        else
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
        }
    }
}

-(void) openBook
{
    if (self.entity.isVerticalMode == YES)
    {
        //        flipBaseViewController.view.frame = CGRectMake(0, 0, frameRect.size.width, frameRect.size.height);      //陈星宇，11.18，屏幕适配， 11.26，返回按钮位置
        flipBaseViewController.view.frame = frameRect;
        self.controlPanelViewController.view.frame =frameRect;
        self.bookviewcontroller.publicCoverBackGroundImageView.frame = frameRect;
    }
    else
    {
        if (iPhone5)
        {
            if (![self.entity.deviceType isEqualToString:iPhone5_book])
            {
                flipBaseViewController.view.frame = CGRectMake(44, 0, frameRect.size.height, frameRect.size.width);      //陈星宇，11.18，屏幕适配， 11.26，返回按钮位置
                self.controlPanelViewController.view.frame = CGRectMake(44, 0, frameRect.size.height, frameRect.size.width);    //陈星宇，11.27
                self.bookviewcontroller.publicCoverBackGroundImageView.frame = CGRectMake(44, 0, frameRect.size.height, frameRect.size.width);
            }
            else
            {
                flipBaseViewController.view.frame = CGRectMake(0, 0, frameRect.size.height, frameRect.size.width);
                self.controlPanelViewController.view.frame = CGRectMake(0, 0, frameRect.size.height, frameRect.size.width);
                self.bookviewcontroller.publicCoverBackGroundImageView.frame = CGRectMake(0, 0, frameRect.size.height, frameRect.size.width);
            }
        }
        else
        {
            flipBaseViewController.view.frame = CGRectMake(0, 0, frameRect.size.height, frameRect.size.width);
            self.controlPanelViewController.view.frame = CGRectMake(0, 0, frameRect.size.height, frameRect.size.width);
            self.bookviewcontroller.publicCoverBackGroundImageView.frame = CGRectMake(0, 0, frameRect.size.height, frameRect.size.width);
        }
    }
    
    if ([self.entity.bookType isEqualToString:@"PDF"] || [self.entity.bookType isEqualToString:@"EPUB"])
    {
        return;
    }
    [TimerComponent resetGlobal];
    [CounterComponent resetGlobal];
    if (self.entity != nil)
    {
//        self.entity.filpType = @"slider_flip";//参数控制  陈星宇，11。03
        if([self.entity.filpType isEqualToString:@"corner_flip"])
        {
           [self.flipBaseViewController initStrategy:@"FLIP_CURVERFLIP"];
        }
        else
        {
            if([self.entity.filpType isEqualToString:@"hard_flip"])
            {
                [self.flipBaseViewController initStrategy:@"HARD_FLIP"];
            }
            else if ([self.entity.filpType isEqualToString:@"slider_flip"])     //陈星宇，11.3
            {
                 [self.flipBaseViewController initStrategy:@"FLIP_SLIDE"];
            }
        }
        self.flipController = self.flipBaseViewController.flipController;
        self.flipController.bookViewController = self.bookviewcontroller; //2013.04.22
        self.flipController.rootPath   = self.rootPath;
        self.flipController.bookEntity = self.entity;
        self.flipController.controlPanelViewController = self.controlPanelViewController;
        [self.flipController openBook];
        [self.controlPanelViewController setup:[self.flipBaseViewController.flipController getPageRect]];
        
        if (!self.entity.hasBookMarkTag) {
            
            if (self.entity.isFree) {
                
                self.entity.showBookMark = YES;
                self.entity.showBookMarkLabel = NO;
            } else {
                
                self.entity.showBookMark = NO;
                self.entity.showBookMarkLabel = NO;
            }
        }
        
        if (!(!self.entity.showBookMark && !self.entity.showBookMarkLabel))
        {
            
            [self.bookviewcontroller addFreeMaskView:[self.flipBaseViewController.flipController getPageRect]];
            self.bookviewcontroller.maskView.hidden = NO;
        }
        else
        {
            if (self.bookviewcontroller.maskView) {
                self.bookviewcontroller.maskView.hidden = YES;
            }
        }

//#if TAIWAN == 1
//        
//        [self.bookviewcontroller addTaiwanMask:[self.flipBaseViewController.flipController getPageRect]];
//        self.bookviewcontroller.maskLable.hidden = NO;
//        
//#endif
    }
}

-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return YES;
    if ([self.entity.bookType isEqualToString:@"PDF"] || [self.entity.bookType isEqualToString:@"EPUB"])
    {
//        if ([self.entity.bookType isEqualToString:@"PDF"])
//        {
//            return YES;
//        }
        if ((interfaceOrientation ==
             UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    if (self.entity.isVerHorMode == YES)
    {
        return [self.flipController checkOrientation:interfaceOrientation];
    }
    else
    {
        if ((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
        {
            if (self.entity.isVerticalMode == YES)
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            if (self.entity.isVerticalMode == NO)
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
}

-(void) strartView
{
//    [self testButton];
    if ([self.entity.bookType isEqualToString:@"PDF"]  || [self.entity.bookType isEqualToString:@"EPUB"])
    {
        return;
    }
    [self.flipController strartView];
}

-(void) changeToOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([self checkOrientation:interfaceOrientation] == YES)
    {
        [self.flipController changeToOrientation:interfaceOrientation];
        self.controlPanelViewController.orientation = interfaceOrientation;
        if ([self.entity.bookType isEqualToString:@"PDF"] || [self.entity.bookType isEqualToString:@"EPUB"])
        {
            CGRect rect;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                if (iPhone5)
                {
                    rect = CGRectMake(0, 0, 320, 568);
                }
                else
                {
                    rect = CGRectMake(0, 0, 320, 480);
                }
            }
            else
            {
                rect = CGRectMake(0, 0, 768, 1024);
            }
//            if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
//            {
//                rect = CGRectMake(0, 0, 1024, 768);
//            }
            [self.controlPanelViewController setup:rect];
//             if ([self.entity.bookType isEqualToString:@"PDF"])
//             {
//                 [_readerViewController willChangeToInterfaceOrientation:interfaceOrientation];
//             }
        }
        else
        {
            [self.controlPanelViewController setup:[self.flipController getPageRect]];
        }
    }
   
}

//- (void)testButton
//{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn.frame = CGRectMake(500, 500, 100, 60);
//    [self.bookviewcontroller.view addSubview:btn];
//    [btn addTarget:self action:@selector(getCurPageIndex) forControlEvents:UIControlEventTouchUpInside];
//}

-(BookType)getBookType
{
    if ([self.entity.bookType isEqualToString:@"PDF"])
    {
        return BookTypePDF;
    }
    else if ([self.entity.bookType isEqualToString:@"EPUB"])
    {
        return BookTypeEpub;
    }
    else
    {
        return BookTypeMedia;
    }
}

- (NSString *)getCurPageIndex
{
    if ([self.entity.bookType isEqualToString:@"PDF"])
    {
        return [NSString stringWithFormat:@"%d", self.readerViewController.currentPage];
    }
    else if ([self.entity.bookType isEqualToString:@"EPUB"])
    {
        return [NSString stringWithFormat:@"%d", self.ePubViewController.curPageIndex];
    }
    else
    {
        return [NSString stringWithFormat:@"%d.%d", self.flipController.currentSectionIndex, self.flipController.currentPageIndex];
    }
}

-(void) close
{
    if ([UIAccelerometer sharedAccelerometer].delegate)
        [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SStaticFontSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[HLDefaultRecord shareRecord] removeAllObjects];
    
    [HLPageDecoder close];
    [self.flipController close];
    if (self.apBook != nil)
    {
        [self.apBook closeBook];
    }
    
}

- (void)dealloc
{
    [self.readerViewController.view removeFromSuperview];
    self.readerViewController = nil;
    [self.ePubViewController.view removeFromSuperview];
    self.ePubViewController = nil;
    [HLPageDecoder setSX:1.0];
    [HLPageDecoder setSY:1.0];
    [HLPageDecoder setSX1:1.0];
    [HLPageDecoder setSY1:1.0];
    [self.bookviewcontroller.view removeFromSuperview];
    [self.bookviewcontroller release];
    [self.rootPath release];
    [self.bookmode release];
    [self.entity release];
    [self.controlPanelViewController.view removeFromSuperview];
    [self.controlPanelViewController release];
    [self.flipBaseViewController release];
    [super dealloc];
}

@end
