//
//  QuizPagingViewController.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 3/5/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "SYPaginatorViewController.h"
#import "QuizEntity.h"

@class QuizComponent;
@class SingleChoiceView;

@interface QuizPagingViewController : SYPaginatorViewController
{
    
}

@property (nonatomic,assign) QuizEntity* entity;
@property (nonatomic,assign) QuizComponent *quizComponent;
@property Boolean isAnswerChecking;


-(void) reloadData;
-(int) getCurrentIndex;
-(SYPageView *) getCurrentView;
-(void) setCurrentPageIndex:(int) pageIndex;
-(void) checkAnswer;
@end
