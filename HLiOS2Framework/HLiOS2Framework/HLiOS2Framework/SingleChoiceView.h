//
//  SingleChoiceView.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 2/25/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizAudioPlayer.h"
#import "QuestionEntity.h"
#import "SYPageView.h"

@class QuizComponent;

@interface SingleChoiceView : SYPageView
{
    
}
@property (nonatomic,retain) UIImageView *qimg;
@property (nonatomic,retain) UIImageView *qimgbg;
@property (nonatomic,retain) UIImageView *qimgfg;
@property (nonatomic,retain) UIImageView *breakLine;
@property (nonatomic,retain) UIImageView *questionImg;
@property (nonatomic,retain) QuizAudioPlayer *audioPlayer;
@property (nonatomic,retain) NSMutableArray *uianswers;
@property (nonatomic,assign) QuestionEntity *qe;
@property (nonatomic,assign) QuizComponent  *component;


-(void) loadQuestion:(QuestionEntity *)questionEntity rooPath:(NSString *)rootPath;
-(void) stopView;
-(void) beginView;
-(void) checkAnswer;

@end
