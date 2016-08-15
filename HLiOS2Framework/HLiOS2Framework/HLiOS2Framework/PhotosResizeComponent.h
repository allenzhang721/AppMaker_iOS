//
//  PhotosResizeComponent.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-30.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "Component.h"
#import "PhotosResizeEntity.h"
#import "HLPushPopPressView.h"
#import "HLPageControl.h"
#import <AVFoundation/AVFoundation.h>
#import "HLMBProgressHUD.h"

@interface PhotosResizeComponent : Component <UIScrollViewDelegate, HLPushPopPressViewDelegate, HLPageControlDelegate, UIGestureRecognizerDelegate>
{
    UILabel *titleLab;
    UILabel *decLab;
    UIView *componentView;
    UIView *topBarView;
    UIView *blackBgView;
    UIImageView *audioImg;
    HLPageControl *curPageControl;
    HLPushPopPressView *pressView;
    UIScrollView *curScrollView;
    float scrWidth;
    float scrHeight;
    int count;
    int curIndex;
    BOOL isLoad;
    
    CGRect originalRect;
    
    
    NSArray *showImgRectArr;
    NSArray *imgOriSizeArr;
    NSMutableArray *imgArray;
    NSMutableArray *imgBgArray;
    NSArray *imgSourceArray;
    
    UIPanGestureRecognizer *panGesture;
    AVAudioPlayer *audioPlayer;
    HLMBProgressHUD *HUD;
    float progress;
    float duration;
    NSTimer *timer;
    
}

@property (nonatomic, retain) PhotosResizeEntity *entity;

@end
