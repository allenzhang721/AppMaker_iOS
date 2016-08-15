//
//  ButtonComponet.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-15.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "ButtonComponet.h"

@implementation ButtonComponet

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        self.entity = (ButtonContainerEntity *)entity;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake([self.entity.x floatValue], [self.entity.y floatValue], [self.entity.width floatValue], [self.entity.height floatValue]);
        [button addTarget:self action:@selector(buttonClickedUp) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(buttonClickedDown) forControlEvents:UIControlEventTouchDown];
        
        NSString *path = [entity.rootPath stringByAppendingPathComponent:entity.dataid];
        NSString *upPath = [path stringByAppendingPathComponent:self.entity.upImgName];
        NSString *downPath = [path stringByAppendingPathComponent:self.entity.downImgName];
        UIImage *upImg = [UIImage imageWithContentsOfFile:upPath];
        UIImage *downImg = [UIImage imageWithContentsOfFile:downPath];
        
//        [button setImage:upImg forState:UIControlStateNormal];
//        [button setImage:downImg forState:UIControlStateSelected];
//        [button setImage:downImg forState:UIControlStateHighlighted];
//        [button setImage:downImg forState:UIControlStateSelected | UIControlStateHighlighted];

        adBtnView = [[ADButtonView alloc]initWithFrame:button.frame];
        adBtnView.upImg = upImg;
        adBtnView.downImg = downImg;
        [adBtnView setup];
        self.uicomponent = adBtnView;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapGesture)]autorelease]];
        
    }
    return self;
}

- (void)buttonClickedUp
{
    [self onTouchEndTouchUp];
}

- (void)buttonClickedDown
{
    [self onTouch];
}

- (void)dealloc
{
    [self.entity release];
    [self.uicomponent removeFromSuperview];
    [self.uicomponent release];
    [super dealloc];
}

@end
