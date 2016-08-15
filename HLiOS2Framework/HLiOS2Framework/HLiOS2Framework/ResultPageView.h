//
//  ResultPageView.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 3/6/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "SYPageView.h"

@class QuizEntity;
@class QuizComponent;
@class QuizPagingViewController;

@interface ResultPageView : SYPageView
{}

@property (nonatomic,assign) QuizEntity *qe;
@property (nonatomic,assign) QuizComponent  *component;
@property (nonatomic,assign) QuizPagingViewController *pvController;

@property (nonatomic,retain) UILabel *resultLable;
@property (nonatomic,retain) UILabel *infoLable;

-(void) checkResult;
@end
