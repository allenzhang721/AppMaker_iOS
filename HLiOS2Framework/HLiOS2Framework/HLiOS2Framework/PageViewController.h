//
//  PageViewController.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-12.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ContainerEntity.h"
#import "Container.h"
#import "Component.h"
#import "PageEntity.h"


@class PageController;

@interface PageViewController : UIViewController <UIGestureRecognizerDelegate, UIAccelerometerDelegate, UIScrollViewDelegate>

#pragma mark -
#pragma mark - Property_objects

@property (nonatomic, retain) PageEntity               *pageEntity;
@property (nonatomic, assign) PageController           *pageController;
@property (nonatomic, assign) NSMutableArray           *curContainerArr;
@property (nonatomic, assign) UIScrollView             *curScrollView;
@property (nonatomic, retain) UIAcceleration           *acceleration;
@property (nonatomic, retain) NSDate                   *lastDate;
@property (nonatomic, retain) UISwipeGestureRecognizer *rightSwipe;
@property (nonatomic, retain) UISwipeGestureRecognizer *leftSwip;
@property (nonatomic, retain) UIView                   *PurchseView;        //Mr.chen, reason, 14.03.30 

#pragma mark -
#pragma mark - Property_values

#pragma mark -
#pragma mark - Property_flag


#pragma mark -
#pragma mark - Public Method

- (id)initWithClear:(BOOL)clear;              // 1.2 ，穿透视图
- (void)loadPageEntity:(PageEntity *) entity;
- (void)addComponent:(Component*)component;
- (void)setupGesture;




@end
