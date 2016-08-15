//
//  iAdComponent.m
//  Core
//
//  Created by Mouee-iMac on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#import "iAdComponent.h"
//#import "Container.h"
//#import "PageController.h"
//
//@implementation iAdComponent
//
//
//- (id)initWithEntity:(ContainerEntity *) entity
//{
//    self = [super init];
//    if (self)
//    {
//        self.iadEntity = (iAdEntity *)entity;
//        [self reloadiAd];
//    }
//    return self;
//}
//
//-(void)stop
//{
//    self.iadEntity = nil;
//    iadView.delegate = nil;
//    [iadView removeFromSuperview];
//    [iadView release];
//    iadView = nil;
//}
//
//- (void)reloadiAd
//{
//    if (iadView)
//    {
//        iadView.delegate = nil;
//        [iadView removeFromSuperview];
//        [iadView release];
//        iadView = nil;
//    }
//    
//    
//    iadView = [[ADBannerView alloc] init];
//    iadView.delegate = self;
//    self.uicomponent = iadView;
//    iadView.hidden = YES;
//}
//
//#pragma adbannerview delegate
//
//- (void)bannerViewDidLoadAd:(ADBannerView *)banner
//{
//    BookEntity *bookEntity = self.container.pageController.bookEntity;
//    if (!bookEntity)
//    {
//        return;
//    }
//    
//    float height = 0;
//    // iPhone { portrait : 320x50, landscape : 480x32 } , iPad { portrait : 768x66, landscape : 1024x66 }
//    if (bookEntity.width == 1024 || bookEntity.width == 768)
//    {
//        height = 66;
//    }
//    else
//    {
//        if (bookEntity.width > bookEntity.height)
//        {
//            height = 32;
//        }
//        else
//        {
//            height = 50;
//        }
//    }
//
//    if ([bookEntity.adPosition isEqualToString:@"bottom"])
//    {
//        top = bookEntity.height - height;
//        iadView.frame = CGRectMake(self.uicomponent.frame.origin.x, top, self.uicomponent.frame.size.width, height);
//    }
//    else
//    {
//        top = 0;
//        iadView.frame = CGRectMake(self.uicomponent.frame.origin.x, 0, self.uicomponent.frame.size.width, self.uicomponent.frame.size.height);
//    }
//    [self performSelector:@selector(delayChange) withObject:nil afterDelay:.1];
//}
//
//- (void)delayChange
//{
//    iadView.frame = CGRectMake(self.uicomponent.frame.origin.x, top, self.uicomponent.frame.size.width, self.uicomponent.frame.size.height);
//    iadView.hidden = NO;
//}
//
//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
//{
//    iadView.hidden = YES;
//}
//
//- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
//{
//    return willLeave;
//}
//
//- (void)bannerViewActionDidFinish:(ADBannerView *)banner
//{
//    
//}
//
//-(void)dealloc
//{
//    if (iadView)
//    {
//        [self stop];
//    }
//    [self.uicomponent removeFromSuperview];     //陈星宇，11.4
//    [self.uicomponent release];
//    [super dealloc];
//}
//
//@end
